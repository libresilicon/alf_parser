grammar ALF;

alf_statement:
	alf_type (index? alf_name index?)? ('=' alf_value)? ';' // See Syntax 1, 5.1
	| alf_type (index? alf_name index?)? ('=' alf_value)? '{' (
		alf_value
		| ':'
		| ';'
	)* '}'
	| alf_type (index? alf_name index?)? ('=' alf_value)? '{' alf_statement* '}';

alf_type: identifier | '@' | ':';

alf_name: identifier | control_expression;

alf_value:
	number
	| multiplier_prefix_symbol
	| identifier
	| quoted_string
	| bit_literal
	| based_literal
	| edge_value
	| arithmetic_expression
	| boolean_expression
	| control_expression;

alf_statement_termination:
	';'
	| '{' (alf_value | ':' | ';')* '}'
	| '{' alf_statement* '}';

character:
	whitespace // See Syntax 2, 6.1
	| letter
	| Digit
	| Special;

whitespace: ' ' | '\t' | '\n' | '\u000B' | '\r' | '\f';

letter: Uppercase | Lowercase;

Uppercase: [A-Z];

Lowercase: [a-z];

Digit: [0-9];

Special:
	[&|^*/%?!:;,'@=.$_()<>{}]
	| '\\'
	| '+'
	| '-'
	| '~'
	| '"'
	| '['
	| ']';

comment:
	in_line_comment // See Syntax 3, 6.2
	| block_comment;

in_line_comment: '//' character* '\n' | '//' character* '\r';

block_comment: '/*' character* '*/';

delimiter: // See Syntax 4, 6.3
	'('
	| ')'
	| '{'
	| '}'
	| '['
	| ']'
	| ':'
	| ';'
	| ',';

operator:
	arithmetic_operator // See Syntax 5, 6.4	
	| boolean_operator
	| relational_operator
	| shift_operator
	| event_operator
	| meta_operator;

arithmetic_operator: '+' | '-' | '*' | '/' | '%' | '**';

boolean_operator:
	'&&'
	| '||'
	| '~&'
	| '~|'
	| '^'
	| '~^'
	| '~'
	| '!'
	| '&'
	| '|';

relational_operator: '==' | '!=' | '>=' | '<=' | '>' | '<';

shift_operator: '<<' | '>>';

event_operator: '->' | '~>' | '<->' | '<~>' | '&>' | '<&>';

meta_operator: '=' | '?' | '@';

number:
	signed_integer // See Syntax 6, 6.5
	| signed_real
	| unsigned_integer
	| unsigned_real;
signed_number: signed_integer | signed_real;
unsigned_number: unsigned_integer | unsigned_real;
integer: signed_integer | unsigned_integer;
signed_integer: sign unsigned_integer;
unsigned_integer: Digit ('_'? Digit)*;

real: signed_real | unsigned_real;
signed_real: sign unsigned_real;
unsigned_real: mantissa exponent? | unsigned_integer exponent;

sign: '+' | '-';
mantissa:
	'.' unsigned_integer
	| unsigned_integer '.' unsigned_integer?;
exponent:
	'E' sign? unsigned_integer
	| 'e' sign? unsigned_integer;
index_value:
	unsigned_integer // See Syntax 7, 6.6
	| atomic_identifier;
index:
	single_index // See Syntax 8, 6.6
	| multi_index;
single_index: '[' index_value ']';
multi_index: '[' index_value ':' index_value ']';
multiplier_prefix_symbol:
	unity letter* // See Syntax 9, 6.7
	| K letter*
	| M E G letter*
	| G letter*
	| M letter*
	| U letter*
	| N letter*
	| P letter*
	| F letter*;
unity: '1';
K: [Kk];
M: [Mm];
E: [Ee];
G: [Gg];
U: [Uu];
N: [Nn];
P: [Pp];
F: [Ff];
multiplier_prefix_value:
	unsigned_number // See Syntax 10, 6.7
	| multiplier_prefix_symbol;
bit_literal:
	alphanumeric_bit_literal // See Syntax 11, 6.8
	| symbolic_bit_literal;
alphanumeric_bit_literal:
	numeric_bit_literal
	| alphabetic_bit_literal;
numeric_bit_literal: '0' | '1';
alphabetic_bit_literal:
	'X'
	| 'Z'
	| 'L'
	| 'H'
	| 'U'
	| 'W'
	| 'x'
	| 'z'
	| 'l'
	| 'h'
	| 'u'
	| 'w';

symbolic_bit_literal: '?' | '*';
based_literal:
	binary_based_literal // See Syntax 12, 6.9
	| octal_based_literal
	| decimal_based_literal
	| hexadecimal_based_literal;
binary_based_literal:
	binary_base bit_literal ('_'? bit_literal)*;
binary_base: '\'B' | '\'b';
octal_based_literal: octal_base octal_digit ('_'? octal_digit)*;
octal_base: '\'O' | '\'o';
octal_digit: bit_literal | '2' | '3' | '4' | '5' | '6' | '7';
decimal_based_literal: decimal_base Digit ('_'? Digit)*;
decimal_base: '\'D' | '\'d';
hexadecimal_based_literal:
	hexadecimal_base hexadecimal_digit ('_'? hexadecimal_digit)*;
hexadecimal_base: '\'H' | '\'h';
hexadecimal_digit:
	octal_digit
	| '8'
	| '9'
	| 'A'
	| 'B'
	| 'C'
	| 'D'
	| 'E'
	| 'F'
	| 'a'
	| 'b'
	| 'c'
	| 'd'
	| 'e'
	| 'f';

boolean_value:
	alphanumeric_bit_literal // See Syntax 13, 6.10
	| based_literal
	| integer;
arithmetic_value:
	number // See Syntax 14, 6.11
	| identifier
	| bit_literal
	| based_literal;
edge_literal:
	bit_edge_literal // See Syntax 15, 6.12
	| based_edge_literal
	| symbolic_edge_literal;
bit_edge_literal: bit_literal bit_literal;
based_edge_literal: based_literal based_literal;
symbolic_edge_literal: '?~' | '?!' | '?-';
edge_value: '(' edge_literal ')';
identifier:
	atomic_identifier // See Syntax 17, 6.13
	| indexed_identifier
	| hierarchical_identifier
	| escaped_identifier;
atomic_identifier:
	non_escaped_identifier
	| placeholder_identifier;
hierarchical_identifier:
	full_hierarchical_identifier
	| partial_hierarchical_identifier;
non_escaped_identifier:
	letter (letter | Digit | '_' | '$' | '#')*;

placeholder_identifier: // See Syntax 19, 6.13.2
	'<' non_escaped_identifier '>';
indexed_identifier: // See Syntax 20, 6.13.3
	atomic_identifier index;
full_hierarchical_identifier: // See Syntax 21, 6.13.4
	atomic_identifier index? '.' atomic_identifier index? (
		'.' atomic_identifier index?
	)*;
partial_hierarchical_identifier: // See Syntax 22, 6.13.5
	atomic_identifier index? ('.' atomic_identifier index?)* '..' (
		atomic_identifier index? ('.' atomic_identifier index?)* '..'
	)* (atomic_identifier index? ( '.' atomic_identifier index?)*)?;
escaped_identifier: // See Syntax 23, 6.13.6
	'\\' escapable_character escapable_character?;
escapable_character: letter | Digit | Special;
keyword_identifier: // See Syntax 24, 6.13.7
	letter ('_'? letter)*;
quoted_string: // See Syntax 25, 6.14
	'"' character* '"';
string_value:
	quoted_string // See Syntax 26, 6.15
	| identifier;
generic_value:
	number // See Syntax 27, 6.16
	| multiplier_prefix_symbol
	| identifier
	| quoted_string
	| bit_literal
	| based_literal
	| edge_value;
vector_expression_macro: '#.' non_escaped_identifier;
generic_object: // See Syntax 28, 6.17
	alias_declaration // See Syntax 29, 7.1
	| constant_declaration
	| class_declaration
	| keyword_declaration
	| semantics_declaration
	| group_declaration
	| template_declaration;
all_purpose_item:
	generic_object // See Syntax 30, 7.2
	| include_statement
	| associate_statement
	| annotation
	| annotation_container
	| arithmetic_model
	| arithmetic_model_container
	| template_instantiation;

annotation:
	single_value_annotation // See Syntax 31, 7.3
	| multi_value_annotation;
annotation_identifier: identifier;
single_value_annotation:
	annotation_identifier '=' annotation_value ';';
multi_value_annotation:
	annotation_identifier '{' annotation_value+ '}';
annotation_value:
	generic_value
	| control_expression
	| boolean_expression
	| arithmetic_expression;
annotation_container_identifier: identifier;
annotation_container:
	annotation_container_identifier '{' annotation+ '}'; // See Syntax 32, 7.4
attribute: 'ATTRIBUTE' '{' identifier+ '}'; // See Syntax 33, 7.5
property:
	'PROPERTY' identifier? '{' annotation+ '}'; // See Syntax 34, 7.6
alias_identifier: identifier;
original_identifier: identifier;
alias_declaration:
	'ALIAS' alias_identifier '=' original_identifier ';' // See Syntax 35, 7.7
	| 'ALIAS' vector_expression_macro '=' '(' vector_expression ')' ';';
constant_identifier: identifier;
constant_declaration:
	'CONSTANT' constant_identifier '=' constant_value ';'; // See Syntax 36, 7.8
constant_value: number | based_literal;
syntax_item_identifier: identifier;
context_annotation: annotation;
keyword_declaration:
	'KEYWORD' keyword_identifier '=' syntax_item_identifier ';' // See Syntax 37, 7.9
	| 'KEYWORD' keyword_identifier '=' syntax_item_identifier '{' context_annotation* '}';
semantics_identifier: identifier;
semantics_declaration:
	'SEMANTICS' semantics_identifier '=' syntax_item_identifier ';' // See Syntax 38, 7.10
	| 'SEMANTICS' semantics_identifier (
		'=' syntax_item_identifier
	)? '{' semantics_item* '}';
valuetype_single_value_annotation: single_value_annotation;
values_multi_value_annotation: multi_value_annotation;
referencetype_annotation: annotation;
default_single_value_annotation: single_value_annotation;
si_model_single_value_annotation: single_value_annotation;
semantics_item:
	context_annotation
	| valuetype_single_value_annotation
	| values_multi_value_annotation
	| referencetype_annotation
	| default_single_value_annotation
	| si_model_single_value_annotation;
class_identifier: identifier;
class_declaration:
	'CLASS' class_identifier ';' // See Syntax 39, 7.12
	| 'CLASS' class_identifier '{' class_item* '}';

class_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation;
group_identifier: identifier;
left_index_value: index_value;
right_index_value: index_value;
group_declaration:
	'GROUP' group_identifier '{' generic_value+ '}' // See Syntax 40, 7.14
	| 'GROUP' group_identifier '{' left_index_value ':' right_index_value '}';
template_identifier: identifier;
template_declaration:
	'TEMPLATE' template_identifier '{' alf_statement+ '}'; // See Syntax 41, 7.15
template_instantiation:
	static_template_instantiation // See Syntax 42, 7.16
	| dynamic_template_instantiation;
static_template_instantiation:
	template_identifier ('=' 'static')? ';'
	| template_identifier ('=' 'static')? '{' generic_value* '}'
	| template_identifier ('=' 'static')? '{' annotation* '}';
dynamic_template_instantiation:
	template_identifier '=' 'dynamic' '{' (
		dynamic_template_instantiation_item
	)? '}';
dynamic_template_instantiation_item:
	annotation
	| arithmetic_model
	| arithmetic_assignment;
arithmetic_assignment: identifier '=' arithmetic_expression ';';
include_statement:
	'INCLUDE' quoted_string ';'; // See Syntax 43, 7.17
format_single_value_annotation: single_value_annotation;
associate_statement:
	'ASSOCIATE' quoted_string ';' // See Syntax 44, 7.18
	| 'ASSOCIATE' quoted_string '{' format_single_value_annotation '}';
revision: 'ALF_REVISION' string_value;
library_specific_object: // See Syntax 45, 7.19
	library // See Syntax 46, 8.1
	| sublibrary
	| cell
	| primitive
	| wire
	| pin
	| pingroup
	| vector
	| node
	| layer
	| via
	| ruler
	| antenna
	| site
	| array
	| blockage
	| port
	| pattern
	| region;
library_identifier: identifier;
library_template_instantiation: template_instantiation;
library:
	'LIBRARY' library_identifier ';' // See Syntax 47, 8.2
	| 'LIBRARY' library_identifier '{' library_item* '}'
	| library_template_instantiation;
library_item: sublibrary | sublibrary_item;
sublibrary_identifier: identifier;
sublibrary_template_instantiation: template_instantiation;
sublibrary:
	'SUBLIBRARY' sublibrary_identifier ';'
	| 'SUBLIBRARY' sublibrary_identifier '{' sublibrary_item* '}'
	| sublibrary_template_instantiation;
sublibrary_item:
	all_purpose_item
	| cell
	| primitive
	| wire
	| layer
	| via
	| ruler
	| antenna
	| array
	| site
	| region;
cell_identifier: identifier;
cell_template_instantiation: template_instantiation;
cell: // See Syntax 48, 8.4
	'CELL' cell_identifier ';'
	| 'CELL' cell_identifier '{' cell_item* '}'
	| cell_template_instantiation;
cell_item:
	all_purpose_item
	| pin
	| pingroup
	| primitive
	| function
	| non_scan_cell
	| test
	| vector
	| wire
	| blockage
	| artwork
	| pattern
	| region;
pin: // See Syntax 49, 8.6
	scalar_pin
	| vector_pin
	| matrix_pin;
pin_identifier: identifier;
scalar_pin_template_instantiation: template_instantiation;
scalar_pin:
	'PIN' pin_identifier ';'
	| 'PIN' pin_identifier '{' scalar_pin_item* '}'
	| scalar_pin_template_instantiation;
scalar_pin_item: all_purpose_item | pattern | port;
vector_pin_template_instantiation: template_instantiation;
vector_pin:
	'PIN' multi_index pin_identifier ';'
	| 'PIN' multi_index pin_identifier '{' vector_pin_item* '}'
	| vector_pin_template_instantiation;
vector_pin_item: all_purpose_item | range;
first_multi_index: multi_index;
second_multi_index: multi_index;
matrix_pin_template_instantiation: template_instantiation;
matrix_pin:
	'PIN' first_multi_index pin_identifier second_multi_index ';'
	| 'PIN' first_multi_index pin_identifier second_multi_index '{' matrix_pin_item* '}'
	| matrix_pin_template_instantiation;
matrix_pin_item: vector_pin_item;
pingroup:
	simple_pingroup // See Syntax 50, 8.7
	| vector_pingroup;
pingroup_identifier: identifier;
simple_pingroup_template_instantiation: template_instantiation;
members_multi_value_annotation: multi_value_annotation;
simple_pingroup:
	'PINGROUP' pingroup_identifier '{' members_multi_value_annotation all_purpose_item* '}'
	| simple_pingroup_template_instantiation;
vector_pingroup_template_instantiation: template_instantiation;
vector_pingroup:
	'PINGROUP' multi_index pingroup_identifier '{' members_multi_value_annotation
		vector_pingroup_item* '}'
	| vector_pingroup_template_instantiation;
vector_pingroup_item: all_purpose_item | range;
primitive_identifier: identifier;
primitive_template_instantiation: template_instantiation;
primitive:
	'PRIMITIVE' primitive_identifier '{' primitive_item* '}' // See Syntax 51, 8.9
	| 'PRIMITIVE' primitive_identifier ';'
	| primitive_template_instantiation;
primitive_item:
	all_purpose_item
	| pin
	| pingroup
	| function
	| test;
wire_identifier: identifier;
wire_template_instantiation: template_instantiation;
wire: // See Syntax 52, 8.10
	'WIRE' wire_identifier '{' wire_item* '}'
	| 'WIRE' wire_identifier ';'
	| wire_template_instantiation;
wire_item: all_purpose_item | node;
node_identifier: identifier;
node_template_instantiation: template_instantiation;
node: // See Syntax 53, 8.12
	'NODE' node_identifier ';'
	| 'NODE' node_identifier '{' node_item* '}'
	| node_template_instantiation;
node_item: all_purpose_item;
vector_template_instantiation: template_instantiation;
vector:
	// See Syntax 54, 8.14
	'VECTOR' control_expression ';'
	| 'VECTOR' control_expression '{' vector_item* '}'
	| vector_template_instantiation;
vector_item: all_purpose_item | wire_instantiation;
layer_identifier: identifier;
layer_template_instantiation: template_instantiation;
layer:
	'LAYER' layer_identifier ';' // See Syntax 55, 8.16
	| 'LAYER' layer_identifier '{' layer_item* '}'
	| layer_template_instantiation;
layer_item: all_purpose_item;
via_identifier: identifier;
via_template_instantiation: template_instantiation;
via:
	'VIA' via_identifier ';' // See Syntax 56, 8.18
	| 'VIA' via_identifier '{' via_item* '}'
	| via_template_instantiation;
via_item: all_purpose_item | pattern | artwork;
rule_identifier: identifier;
rule_template_instantiation: template_instantiation;
ruler:
	'RULE' rule_identifier ';' // See Syntax 57, 8.20
	| 'RULE' rule_identifier '{' rule_item* '}'
	| rule_template_instantiation;
rule_item:
	all_purpose_item
	| pattern
	| region
	| via_instantiation;
antenna_identifier: identifier;
antenna_template_instantiation: template_instantiation;
antenna: // See Syntax 58, 8.21
	'ANTENNA' antenna_identifier ';'
	| 'ANTENNA' antenna_identifier '{' antenna_item* '}'
	| antenna_template_instantiation;
antenna_item: all_purpose_item | region;

blockage_identifier: identifier;
blockage_template_instantiation: template_instantiation;
blockage:
	'BLOCKAGE' blockage_identifier ';' // See Syntax 59, 8.22
	| 'BLOCKAGE' blockage_identifier '{' blockage_item* '}'
	| blockage_template_instantiation;
blockage_item:
	all_purpose_item
	| pattern
	| region
	| ruler
	| via_instantiation;
port_identifier: identifier;
port_template_instantiation: template_instantiation;
port:
	'PORT' port_identifier ';' // See Syntax 60, 8.23
	'{' port_item* '}'
	| 'PORT' port_identifier ';'
	| port_template_instantiation;
port_item:
	all_purpose_item
	| pattern
	| region
	| ruler
	| via_instantiation;
site_identifier: identifier;
site_template_instantiation: identifier;
site:
	'SITE' site_identifier ';' // See Syntax 61, 8.25
	| 'SITE' site_identifier '{' site_item* '}'
	| site_template_instantiation;
width_arithmetic_model: arithmetic_model;
height_arithmetic_model: arithmetic_model;
site_item:
	all_purpose_item
	| width_arithmetic_model
	| height_arithmetic_model;
array_identifier: identifier;
array_template_instantiation: template_instantiation;
array:
	'ARRAY' array_identifier ';' // See Syntax 62, 8.27
	| 'ARRAY' array_identifier '{' array_item* '}'
	| array_template_instantiation;
array_item: all_purpose_item | geometric_transformation;
pattern_identifier: identifier;
pattern_template_instantiation: template_instantiation;
pattern:
	'PATTERN' pattern_identifier ';' // See Syntax 63, 8.29
	| 'PATTERN' pattern_identifier '{' pattern_item* '}'
	| pattern_template_instantiation;
pattern_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation;
region_name_identifier: identifier;
region_template_instantiation: template_instantiation;
region:
	'REGION' region_name_identifier ';' // See Syntax 64, 8.31
	| 'REGION' region_name_identifier '{' region_item* '}'
	| region_template_instantiation;
boolean_single_value_annotation: single_value_annotation;
region_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation
	| boolean_single_value_annotation;
function_template_instantiation: template_instantiation;
function:
	'FUNCTION' '{' function_item+ // See Syntax 65, 9.1
	'}'
	| function_template_instantiation;
function_item:
	all_purpose_item
	| behavior
	| structure
	| statetable;
test_template_instantiation: template_instantiation;
test:
	'TEST' '{' test_item+ '}' // See Syntax 66, 9.2
	| test_template_instantiation;
test_item: all_purpose_item | behavior | statetable;
pin_variable_identifier: identifier;
pin_variable: pin_variable_identifier;
pin_value: // See Syntax 67, 9.3.1
	pin_variable
	| boolean_value;
pin_assignment:
	pin_variable '=' pin_value ';'; // See Syntax 68, 9.3.2
behavior_template_instantiation: template_instantiation;
behavior:
	'BEHAVIOR' '{' behavior_item+ '}' // See Syntax 69, 9.4
	| behavior_template_instantiation;
behavior_item_template_instantiation: template_instantiation;
behavior_item:
	boolean_assignment
	| control_statement
	| primitive_instantiation
	| behavior_item_template_instantiation;
boolean_assignment: pin_variable '=' boolean_expression ';';
control_statement:
	primary_control_statement alternative_control_statement*;
primary_control_statement:
	'@' control_expression '{' boolean_assignment+ '}';
alternative_control_statement:
	':' control_expression '{' boolean_assignment+ '}';
primitive_instantiation:
	primitive_identifier identifier? '{' pin_value+ '}'
	| primitive_identifier identifier? '{' boolean_assignment+ '}';
structure_template_instantiation: template_instantiation;
structure: // See Syntax 70, 9.5
	'STRUCTURE' '{' cell_instantiation+ '}'
	| structure_template_instantiation;
cell_reference_identifier: identifier;
cell_instance_identifier: identifier;
cell_instantiation_template_instantiation:
	template_instantiation;
cell_instantiation:
	cell_reference_identifier cell_instance_identifier ';'
	| cell_reference_identifier cell_instance_identifier '{' cell_instance_pin_value* '}'
	| cell_reference_identifier cell_instance_identifier '{' cell_instance_pin_assignment* '}'
	| cell_instantiation_template_instantiation;
cell_reference_pin_variable: pin_variable;
cell_instance_pin_value: pin_value;
cell_instance_pin_assignment:
	cell_reference_pin_variable '=' cell_instance_pin_value ';';
statetable_template_instantiation: template_instantiation;
statetable:
	'STATETABLE' identifier? '{' statetable_header statetable_row+ '}'
	// See Syntax 71, 9.6
	| statetable_template_instantiation;
output_pin_variable: pin_variable;
statetable_header:
	input_pin_variable+ ':' output_pin_variable+ ';';
statetable_row:
	statetable_control_values ':' statetable_data_values ';';
statetable_control_values: statetable_control_value+;
statetable_control_value:
	boolean_value
	| symbolic_bit_literal
	| edge_value;
statetable_data_values: statetable_data_value+;
input_pin_variable: pin_variable;
statetable_data_value:
	boolean_value
	| '(' ('!')? input_pin_variable ')'
	| '(' ('~')? input_pin_variable ')';
non_scan_cell_template_instantiation: template_instantiation;
non_scan_cell:
	'NON_SCAN_CELL' '=' // See Syntax 72, 9.7
	non_scan_cell_reference
	| 'NON_SCAN_CELL' '{' non_scan_cell_reference+ '}'
	| non_scan_cell_template_instantiation;
non_scan_cell_identifier: identifier;
scan_cell_pin_identifier: identifier;
non_scan_cell_pin_identifier: identifier;
non_scan_cell_reference:
	non_scan_cell_identifier '{' scan_cell_pin_identifier '}'
	| non_scan_cell_identifier '{' (
		non_scan_cell_pin_identifier '=' scan_cell_pin_identifier ';'
	)* '}';
range:
	'RANGE' '{' index_value ':' index_value '}'; // See Syntax 73, 9.8
boolean_expression:
	'(' boolean_expression ')' // See Syntax 74, 9.9
	| boolean_value
	| identifier
	| boolean_unary_operator boolean_expression
	| boolean_expression boolean_binary_operator boolean_expression
	| boolean_expression '?' boolean_expression ':' boolean_expression;
boolean_unary_operator:
	'!'
	| '~'
	| '&'
	| '~&'
	| '|'
	| '~|'
	| '^'
	| '~^';
boolean_binary_operator:
	| '&'
	| '&&'
	| '~&'
	| '|'
	| '||'
	| '~|'
	| '^'
	| '~^'
	| relational_operator
	| arithmetic_operator
	| shift_operator;
vector_expression:
	// See Syntax 75, 9.12
	'(' vector_expression ')'
	| single_event
	| vector_expression vector_operator vector_expression
	| boolean_expression '?' vector_expression ':' vector_expression
	| boolean_expression control_and vector_expression
	| vector_expression control_and boolean_expression
	| vector_expression_macro;
single_event: edge_literal boolean_expression;
vector_operator: event_operator | event_and | event_or;
event_and: '&' | '&&';
event_or: '|' | '||';
control_and: '&' | '&&';
control_expression:
	'(' vector_expression ')'
	| '(' boolean_expression ')';
wire_instance_identifier: identifier;
wire_reference_identifier: identifier;
wire_instantiation_template_instantiation:
	template_instantiation;
wire_instantiation:
	// See Syntax 76, 9.15
	wire_reference_identifier wire_instance_identifier ';'
	| wire_reference_identifier wire_instance_identifier '{' wire_instance_pin_value* '}'
	| wire_reference_identifier wire_instance_identifier '{' wire_instance_pin_assignment* '}'
	| wire_instantiation_template_instantiation;
wire_reference_pin_variable: pin_variable;
wire_instance_pin_value: pin_value;
wire_instance_pin_assignment:
	wire_reference_pin_variable '=' wire_instance_pin_value ';';
geometric_model_template_instantiation: template_instantiation;
geometric_model_identifier: identifier;
geometric_model:
	non_escaped_identifier geometric_model_identifier? '{' geometric_model_item geometric_model_item
		* '}' // See Syntax 77, 9.16
	| geometric_model_template_instantiation;
point_to_point_single_value_annotation: single_value_annotation;
geometric_model_item:
	point_to_point_single_value_annotation
	| coordinates;
coordinates: 'COORDINATES' '{' point+ '}';
x_number: number;
y_number: number;
point: x_number y_number;
geometric_transformation:
	shift // See Syntax 78, 9.18
	| rotate
	| flip
	| repeat;
shift: 'SHIFT' '{' x_number y_number '}';
rotate: 'ROTATE' '=' number ';';
flip: 'FLIP' '=' number ';';
repeat:
	'REPEAT' ('=' unsigned_integer)* '{' geometric_transformation+ '}';
artwork_template_instantiation: template_instantiation;
artwork:
	'ARTWORK' '=' artwork_identifier ';' // See Syntax 79, 9.19
	| 'ARTWORK' '=' artwork_reference
	| 'ARTWORK' '{' artwork_reference+ '}'
	| artwork_template_instantiation;
artwork_identifier: identifier;
cell_pin_identifier: pin_identifier;
artwork_pin_identifier: pin_identifier;
artwork_reference:
	artwork_identifier '{' geometric_transformation* cell_pin_identifier* '}'
	| artwork_identifier '{' geometric_transformation* (
		artwork_pin_identifier '=' cell_pin_identifier ';'
	)* '}';
instance_identifier: identifier;
via_instantiation:
	via_identifier instance_identifier ';' // See Syntax 80, 9.20
	| via_identifier instance_identifier '{' geometric_transformation* '}';
arithmetic_expression:
	'(' // See Syntax 81, 10.1
	arithmetic_expression ')'
	| arithmetic_value
	| identifier
	| boolean_expression '?' arithmetic_expression ':' arithmetic_expression
	| sign arithmetic_expression
	| arithmetic_expression arithmetic_operator arithmetic_expression
	| macro_arithmetic_operator '(' arithmetic_expression (
		',' arithmetic_expression
	)* ')';
macro_arithmetic_operator:
	'abs'
	| 'exp'
	| 'log'
	| 'min'
	| 'max';
arithmetic_model_template_instantiation: template_instantiation;
arithmetic_model: // See Syntax 82, 10.3
	trivial_arithmetic_model
	| partial_arithmetic_model
	| full_arithmetic_model
	| arithmetic_model_template_instantiation;
trivial_arithmetic_model:
	// See Syntax 83, 10.3
	arithmetic_model_identifier name_identifier? '=' arithmetic_value ';'
	| arithmetic_model_identifier name_identifier? '=' arithmetic_value '{'
		arithmetic_model_qualifier* '}';
partial_arithmetic_model:
	arithmetic_model_identifier name_identifier? '{' partial_arithmetic_model_item* '}';
// See Syntax 84, 10.3
partial_arithmetic_model_item:
	arithmetic_model_qualifier
	| table
	| trivial_min_max;
full_arithmetic_model:
	arithmetic_model_identifier name_identifier? '{' arithmetic_model_qualifier*
		arithmetic_model_body arithmetic_model_qualifier* '}'; // See Syntax 85, 10.3
arithmetic_model_body:
	header_table_equation trivial_min_max? // See Syntax 86, 10.3
	| min_typ_max
	| arithmetic_submodel+;
arithmetic_model_qualifier:
	inheritable_arithmetic_model_qualifier // See Syntax 87, 10.3
	| non_inheritable_arithmetic_model_qualifier;
inheritable_arithmetic_model_qualifier:
	annotation
	| annotation_container
	| from_to;
non_inheritable_arithmetic_model_qualifier:
	auxiliary_arithmetic_model
	| violation;
header_table_equation:
	header table // See Syntax 88, 10.4
	| header equation;
header:
	'HEADER' '{' header_arithmetic_model+ '}'; // See Syntax 89, 10.4
header_arithmetic_model:
	arithmetic_model_identifier name_identifier? '{' header_arithmetic_model_item* '}';
header_arithmetic_model_item:
	inheritable_arithmetic_model_qualifier
	| table
	| trivial_min_max;
equation_template_instantiation: template_instantiation;
equation:
	'EQUATION' '{' arithmetic_expression '}' // See Syntax 90, 10.4
	| equation_template_instantiation;
table: 'TABLE' '{' arithmetic_value+;
min_typ_max:
	min_max // See Syntax 92, 10.5
	| min? typ max?;
min_max: min | max | min max;
min: trivial_min | non_trivial_min;
max: trivial_max | non_trivial_max;
typ: trivial_typ | non_trivial_typ;
non_trivial_min:
	'MIN' '=' arithmetic_value '{' violation '}' // See Syntax 93, 10.5
	| 'MIN' '{' violation? header_table_equation '}';
non_trivial_max:
	'MAX' '=' arithmetic_value '{' violation '}'
	| 'MAX' '{' violation? header_table_equation '}';
non_trivial_typ: 'TYP' '{' header_table_equation '}';
trivial_min_max:
	trivial_min // See Syntax 94, 10.5
	| trivial_max
	| trivial_min trivial_max;
trivial_min: 'MIN' '=' arithmetic_value ';';
trivial_max: 'MAX' '=' arithmetic_value ';';
trivial_typ: 'TYP' '=' arithmetic_value ';';
auxiliary_arithmetic_model:
	arithmetic_model_identifier '=' arithmetic_value ';' // See Syntax 95, 10.6
	| arithmetic_model_identifier ('=' arithmetic_value)? '{' inheritable_arithmetic_model_qualifier
		+ '}';
arithmetic_submodel_template_instantiation:
	template_instantiation;
arithmetic_submodel:
	arithmetic_submodel_identifier '=' arithmetic_value ';' // See Syntax 96, 10.7
	| arithmetic_submodel_identifier '{' violation? min_max '}'
	| arithmetic_submodel_identifier '{' header_table_equation (
		trivial_min_max
	)? '}'
	| arithmetic_submodel_identifier '{' min_typ_max '}'
	| arithmetic_submodel_template_instantiation;
arithmetic_model_container_identifier: identifier;
arithmetic_model_container:
	limit_arithmetic_model_container // See Syntax 97, 10.8.1
	| early_late_arithmetic_model_container
	| arithmetic_model_container_identifier '{' arithmetic_model+ '}';
limit_arithmetic_model_container:
	'LIMIT' '{' limit_arithmetic_model+ '}'; // See Syntax 98, 10.8.2
arithmetic_model_identifier: identifier;
name_identifier: identifier;
limit_arithmetic_model:
	arithmetic_model_identifier name_identifier? '{' arithmetic_model_qualifier*
		limit_arithmetic_model_body '}';
limit_arithmetic_model_body:
	limit_arithmetic_submodel+
	| min_max;
arithmetic_submodel_identifier: identifier;
limit_arithmetic_submodel:
	arithmetic_submodel_identifier '{' violation? min_max '}';
early_late_arithmetic_model_container:
	early_arithmetic_model_container // See Syntax 99, 10.8.3
	| late_arithmetic_model_container
	| early_arithmetic_model_container late_arithmetic_model_container;
early_late_arithmetic_model: arithmetic_model;
early_arithmetic_model_container:
	'EARLY' '{' early_late_arithmetic_model+ '}';
late_arithmetic_model_container:
	'LATE' '{' early_late_arithmetic_model+ '}';
delay_arithmetic_model: arithmetic_model;
retain_arithmetic_model: arithmetic_model;
slewrate_arithmetic_model: arithmetic_model;
late_arithmetic_model:
	delay_arithmetic_model
	| retain_arithmetic_model
	| slewrate_arithmetic_model;
violation_template_instantiation: template_instantiation;
violation:
	'VIOLATION' '{' violation_item+ '}' // See Syntax 100, 10.10
	| violation_template_instantiation;
message_type_single_value_annotation: single_value_annotation;
message_single_value_annotation: single_value_annotation;
violation_item:
	message_type_single_value_annotation
	| message_single_value_annotation
	| behavior;
from_to:
	from // See Syntax 101, 10.12
	| to
	| from to;
from: 'FROM' '{' from_to_item+ '}';
to: 'TO' '{' from_to_item+ '}';

pin_reference_single_value_annotation: single_value_annotation;
edge_number_single_value_annotation: single_value_annotation;
threshold_arithmetic_model: arithmetic_model;
from_to_item:
	pin_reference_single_value_annotation
	| edge_number_single_value_annotation
	| threshold_arithmetic_model;
