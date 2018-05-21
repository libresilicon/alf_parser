grammar ALF;

alf_statement:
	type = alf_type (
		left_index = index? name = alf_name right_index = index?
	)? ('=' assign_value = alf_value)? (
		';'
		| '{' ( values += alf_value | ':' | ';')* '}'
		| '{' statements += alf_statement* '}'
	); // See Syntax 1, 5.1

alf_type: identifier | '@' | ':';
alf_name: identifier | control_expression;
alf_value:
	Number
	| multiplier_prefix_symbol
	| identifier
	| Quoted_string
	| Bit_literal
	| Based_literal
	| edge_value
	| arithmetic_expression
	| boolean_expression
	| control_expression;

// alf_statement_termination: ';' | '{' (alf_value | ':' | ';')* '}' | '{' alf_statement* '}';

fragment Character: // See Syntax 2, 6.1
	Letter
	| Digit
	| Special
	| Whitespace;

Whitespace: [ \t\n\u000B\r\f] -> channel (HIDDEN);

Letter: [A-Za-z];

fragment Digit: [0-9];
fragment Special: [&|^~+\-*/%?!:;,"'@=\\.$_#()<>[\]{}];

// Comment: In_line_comment | Block_comment; // See Syntax 3, 6.2
In_line_comment: '//' Character* [\n\r] -> channel (HIDDEN);
Block_comment: '/*' Character* '*/' -> channel (HIDDEN);

// Delimiter: [(){}[\]:;,]; // See Syntax 4, 6.3

// operator_: arithmetic_operator | boolean_operator | relational_operator | shift_operator |
// event_operator | meta_operator; // See Syntax 5, 6.4

Plus: '+';
Minus: '-';
Multiply: '*';
Divide: '/';
Modulus: '%';
Power: '**';
arithmetic_operator:
	Plus
	| Minus
	| Multiply
	| Divide
	| Modulus
	| Power;

LogicAnd: '&&';
LogicOr: '||';
NotAnd: '~&';
NotOr: '~|';
Xor: '^';
NotXor: '~^';
Not: '~';
LogicNot: '!';
And: '&';
Or: '|';
// boolean_operator: LogicAnd | LogicOr | NotAnd | NotOr | Xor | NotXor | Not | LogicNot | And | Or;

Equal: '==';
NotEqual: '!=';
GreaterOrEqual: '>=';
LesserOrEqual: '<=';
Greater: '>';
Lesser: '<';
relational_operator:
	Equal
	| NotEqual
	| GreaterOrEqual
	| LesserOrEqual
	| Greater
	| Lesser;

ShiftLeft: '<<';
ShiftRight: '>>';
shift_operator: ShiftLeft | ShiftRight;

ImmediatelyFollowedBy: '->';
EventuallyFollowedBy: '~>';
ImmediatelyFollowingEachOther: '<->';
EventuallyFollowingEachOther: '<~>';
SimultaneousOrImmediatelyFollowedBy: '&>';
SimultaneousOrImmediatelyFollowingEachOther: '<&>';
event_operator:
	ImmediatelyFollowedBy
	| EventuallyFollowedBy
	| ImmediatelyFollowingEachOther
	| EventuallyFollowingEachOther
	| SimultaneousOrImmediatelyFollowedBy
	| SimultaneousOrImmediatelyFollowingEachOther;

// Assignment: '='; Condition: '?'; Control: '@'; 

// meta_operator: Assignment | Condition | Control;

Number:
	Signed_integer
	| Signed_Real
	| Unsigned_integer
	| Unsigned_Real; // See Syntax 6, 6.5
//signed_number: Signed_integer | Signed_Real;
unsigned_number: Unsigned_integer | Unsigned_Real;
Integer: Signed_integer | Unsigned_integer;
Signed_integer: Sign Unsigned_integer;
Unsigned_integer: Digit ('_'? Digit)*;

//Real: Signed_Real | Unsigned_Real;
Signed_Real: Sign Unsigned_Real;
Unsigned_Real: Mantissa Exponent? | Unsigned_integer Exponent;

fragment Sign: [+-];
fragment Mantissa:
	'.' Unsigned_integer
	| Unsigned_integer '.' Unsigned_integer?;
fragment Exponent: [eE] Sign? Unsigned_integer;
index_value:
	Unsigned_integer
	| atomic_identifier; // See Syntax 7, 6.6
index: single_index | multi_index; // See Syntax 8, 6.6
single_index: '[' index_value ']';
multi_index:
	'[' from_index = index_value ':' until_index = index_value ']';

multiplier_prefix_symbol:
	(
		Unity
		| Kilo
		| Mega
		| Giga
		| Milli
		| Micro
		| Nano
		| Pico
		| Femto
	) Letter*; // See Syntax 9, 6.7

Unity: '1';
Kilo: [Kk];
Mega: [Mm] [Ee] [Gg];
Milli: [Mm];
Giga: [Gg];
Micro: [Uu];
Nano: [Nn];
Pico: [Pp];
Femto: [Ff];

multiplier_prefix_value:
	unsigned_number
	| multiplier_prefix_symbol; // See Syntax 10, 6.7
Bit_literal:
	Alphanumeric_bit_literal
	| Symbolic_bit_literal; // See Syntax 11, 6.8
fragment Alphanumeric_bit_literal:
	Numeric_bit_literal
	| Alphabetic_bit_literal;
fragment Numeric_bit_literal: [01];
fragment Alphabetic_bit_literal: [XZLHUWxzlhuw];
Symbolic_bit_literal: [?*];

Based_literal:
	Binary_Based_literal
	| Octal_Based_literal
	| Decimal_Based_literal
	| Hexadecimal_Based_literal; // See Syntax 12, 6.9
Binary_Based_literal:
	Binary_base Bit_literal ('_'? Bit_literal)*;
fragment Binary_base: '\'' [Bb];
Octal_Based_literal: Octal_base Octal_digit ('_'? Octal_digit)*;
fragment Octal_base: '\'' [Oo];
fragment Octal_digit: Bit_literal | [234567];
Decimal_Based_literal: Decimal_base Digit ('_'? Digit)*;
fragment Decimal_base: '\'' [Dd];
Hexadecimal_Based_literal:
	Hexadecimal_base Hexadecimal_digit ('_'? Hexadecimal_digit)*;
fragment Hexadecimal_base: '\'' [Hh];
fragment Hexadecimal_digit: Octal_digit | [89ABCDEFabcdef];

Boolean_value:
	Alphanumeric_bit_literal
	| Based_literal
	| Integer; // See Syntax 13, 6.10
arithmetic_value:
	Number
	| identifier
	| Bit_literal
	| Based_literal; // See Syntax 14, 6.11
edge_literal:
	Bit_edge_literal
	| Based_edge_literal
	| Symbolic_edge_literal; // See Syntax 15, 6.12
Bit_edge_literal: Bit_literal Bit_literal;
Based_edge_literal: Based_literal Based_literal;
Symbolic_edge_literal: '?~' | '?!' | '?-';
edge_value: '(' edge_literal ')';
identifier:
	atomic_identifier
	| indexed_identifier
	| hierarchical_identifier
	| Escaped_identifier; // See Syntax 17, 6.13
atomic_identifier:
	Non_escaped_identifier
	| Placeholder_identifier;
hierarchical_identifier:
	full_hierarchical_identifier
	| partial_hierarchical_identifier;
Non_escaped_identifier:
	Letter (Letter | Digit | '_' | '$' | '#')*;

Placeholder_identifier:
	'<' Non_escaped_identifier '>'; // See Syntax 19, 6.13.2
indexed_identifier:
	atomic_identifier index; // See Syntax 20, 6.13.3
optional_indexed_identifier: atomic_identifier index?;
full_hierarchical_identifier:
	list += optional_indexed_identifier (
		'.' list += optional_indexed_identifier
	)+; // See Syntax 21, 6.13.4
partial_hierarchical_identifier:
	(
		from_list += optional_indexed_identifier (
			'.' from_list += optional_indexed_identifier
		)* '..'
	)+ (
		until_list += optional_indexed_identifier (
			'.' until_list += optional_indexed_identifier
		)*
	)?; // See Syntax 22, 6.13.5

Escaped_identifier:
	'\\' Escapable_character+; // See Syntax 23, 6.13.6
fragment Escapable_character: Letter | Digit | Special;
Keyword_identifier:
	Letter ('_'? Letter)*; // See Syntax 24, 6.13.7
Quoted_string: '"' ('\\' . | ~'"')* '"'; // See Syntax 25, 6.14

string_value: Quoted_string | identifier; // See Syntax 26, 6.15
generic_value:
	Number
	| multiplier_prefix_symbol
	| identifier
	| Quoted_string
	| Bit_literal
	| Based_literal
	| edge_value; // See Syntax 27, 6.16
Vector_expression_macro:
	'#.' Non_escaped_identifier; // See Syntax 28, 6.17

generic_object:
	alias_declaration
	| constant_declaration
	| class_declaration
	| keyword_declaration
	| semantics_declaration
	| group_declaration
	| template_declaration; // See Syntax 29, 7.1
all_purpose_item:
	generic_object
	| include_statement
	| associate_statement
	| annotation
	| annotation_container
	| arithmetic_model
	| arithmetic_model_container
	| template_instantiation; // See Syntax 30, 7.2

annotation:
	single_value_annotation
	| multi_value_annotation; // See Syntax 31, 7.3
single_value_annotation: identifier '=' annotation_value ';';
multi_value_annotation: identifier '{' annotation_value+ '}';
annotation_value:
	generic_value
	| control_expression
	| boolean_expression
	| arithmetic_expression;
annotation_container:
	id = identifier '{' annotations += annotation+ '}'; // See Syntax 32, 7.4

attribute:
	'ATTRIBUTE' '{' attributes += identifier+ '}'; // See Syntax 33, 7.5
property:
	'PROPERTY' id = identifier? '{' annotations += annotation+ '}'; // See Syntax 34, 7.6

alias_declaration:
	'ALIAS' (
		id = identifier '=' original = identifier
		| macro = Vector_expression_macro '=' '(' expression = vector_expression ')'
	) ';'; // See Syntax 35, 7.7
constant_declaration:
	'CONSTANT' id = identifier '=' value = constant_value ';'; // See Syntax 36, 7.8
constant_value: Number | Based_literal;

keyword_declaration:
	'KEYWORD' id = Keyword_identifier '=' target = identifier (
		';'
		| '{' annotations += annotation* '}'
	); // See Syntax 37, 7.9

semantics_declaration:
	'SEMANTICS' id = identifier (
		'=' syntax_item = identifier ';'
		| ('=' syntax_item = identifier)? '{' semantics += semantics_item* '}'
	); // See Syntax 38, 7.10
semantics_item:
	annotation
	| valuetype = single_value_annotation
	| values = multi_value_annotation
	| referencetype = annotation
	| default_ = single_value_annotation
	| si_model = single_value_annotation;

class_declaration:
	'CLASS' id = identifier (';' | '{' body += class_item* '}'); // See Syntax 39, 7.12
class_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation;

group_declaration:
	'GROUP' id = identifier (
		'{' values += generic_value+ '}'
		| '{' left = index_value ':' right = index_value '}'
	); // See Syntax 40, 7.14

template_declaration:
	'TEMPLATE' id = identifier '{' statements += alf_statement+ '}'; // See Syntax 41, 7.15

template_instantiation:
	static_template_instantiation // See Syntax 42, 7.16
	| dynamic_template_instantiation;
static_template_instantiation:
	id = identifier ('=' 'static')? (
		';'
		| '{' values += generic_value* '}'
		| '{' annotations += annotation* '}'
	);
dynamic_template_instantiation:
	id = identifier '=' 'dynamic' '{' items += dynamic_template_instantiation_item* '}';
dynamic_template_instantiation_item:
	annotation
	| arithmetic_model
	| arithmetic_assignment;
arithmetic_assignment: identifier '=' arithmetic_expression ';';

include_statement:
	'INCLUDE' target = Quoted_string ';'; // See Syntax 43, 7.17

associate_statement:
	'ASSOCIATE' target = Quoted_string (
		';'
		| '{' format = single_value_annotation '}'
	); // See Syntax 44, 7.18

revision: 'ALF_REVISION' string_value; // See Syntax 45, 7.19

library_specific_object:
	library
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
	| region; // See Syntax 46, 8.1
library:
	'LIBRARY' id = identifier (
		';'
		| '{' body += library_item* '}'
	)
	| library_template = template_instantiation; // See Syntax 47, 8.2
library_item: sublibrary | sublibrary_item;

sublibrary:
	'SUBLIBRARY' id = identifier (
		';'
		| '{' body += sublibrary_item* '}'
	)
	| sublibray_template = template_instantiation;
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

cell:
	'CELL' id = identifier (';' | '{' body += cell_item* '}')
	| cell_template = template_instantiation; // See Syntax 48, 8.4
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

pin: scalar_pin | vector_pin | matrix_pin; // See Syntax 49, 8.6

scalar_pin:
	'PIN' id = identifier (
		';'
		| '{' body += scalar_pin_item* '}'
	)
	| scalar_pin_template = template_instantiation;
scalar_pin_item: all_purpose_item | pattern | port;

vector_pin:
	'PIN' pin_index = multi_index id = identifier (
		';'
		| '{' body += vector_pin_item* '}'
	)
	| vector_pin_template = template_instantiation;
vector_pin_item: all_purpose_item | range;

matrix_pin:
	'PIN' first = multi_index id = identifier second = multi_index (
		';'
		| '{' body += matrix_pin_item* '}'
	)
	| matrix_pin_template = template_instantiation;
matrix_pin_item: vector_pin_item;

pingroup:
	simple_pingroup
	| vector_pingroup; // See Syntax 50, 8.7

simple_pingroup:
	'PINGROUP' id = identifier '{' pingroup_annotation = multi_value_annotation body +=
		all_purpose_item* '}'
	| template_instantiation;
vector_pingroup:
	'PINGROUP' vector_index = multi_index id = identifier '{' pingroup_annotation =
		multi_value_annotation body += vector_pingroup_item* '}'
	| template_instantiation;

vector_pingroup_item: all_purpose_item | range;
primitive:
	'PRIMITIVE' id = identifier (
		';'
		| '{' body += primitive_item* '}'
	)
	| template_instantiation; // See Syntax 51, 8.9
primitive_item:
	all_purpose_item
	| pin
	| pingroup
	| function
	| test;

wire:
	'WIRE' id = identifier (';' | '{' body += wire_item* '}')
	| template_instantiation; // See Syntax 52, 8.10
wire_item: all_purpose_item | node;

node:
	'NODE' id = identifier (';' | '{' body += node_item* '}')
	| template_instantiation; // See Syntax 53, 8.12
node_item: all_purpose_item;

vector:
	'VECTOR' expr = control_expression (
		';'
		| '{' body += vector_item* '}'
	)
	| template_instantiation; // See Syntax 54, 8.14
vector_item: all_purpose_item | wire_instantiation;

layer:
	'LAYER' id = identifier (';' | '{' body += layer_item* '}')
	| template_instantiation; // See Syntax 55, 8.16
layer_item: all_purpose_item;

via:
	'VIA' id = identifier (';' | '{' body += via_item* '}')
	| template_instantiation; // See Syntax 56, 8.18
via_item: all_purpose_item | pattern | artwork;

ruler:
	'RULE' id = identifier (';' | '{' body += rule_item* '}')
	| template_instantiation; // See Syntax 57, 8.20
rule_item:
	all_purpose_item
	| pattern
	| region
	| via_instantiation;

antenna:
	'ANTENNA' id = identifier (
		';'
		| '{' body += antenna_item* '}'
	)
	| template_instantiation; // See Syntax 58, 8.21
antenna_item: all_purpose_item | region;

blockage:
	'BLOCKAGE' id = identifier (
		';'
		| '{' body += blockage_item* '}'
	)
	| template_instantiation; // See Syntax 59, 8.22
blockage_item:
	all_purpose_item
	| pattern
	| region
	| ruler
	| via_instantiation;

port:
	'PORT' id = identifier (';' | '{' body += port_item* '}')
	| template_instantiation; // See Syntax 60, 8.23
port_item:
	all_purpose_item
	| pattern
	| region
	| ruler
	| via_instantiation;

site:
	'SITE' id = identifier (';' | '{' body += site_item* '}')
	| template_instantiation; // See Syntax 61, 8.25
site_item:
	all_purpose_item
	| width = arithmetic_model
	| height = arithmetic_model;

array:
	'ARRAY' id = identifier (';' | '{' body += array_item* '}')
	| template_instantiation; // See Syntax 62, 8.27
array_item: all_purpose_item | geometric_transformation;

pattern:
	'PATTERN' id = identifier (
		';'
		| '{' body += pattern_item* '}'
	)
	| template_instantiation; // See Syntax 63, 8.29
pattern_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation;

region:
	'REGION' id = identifier (';' | '{' body += region_item* '}')
	| template_instantiation; // See Syntax 64, 8.31
region_item:
	all_purpose_item
	| geometric_model
	| geometric_transformation
	| boolean_ = single_value_annotation;
function:
	'FUNCTION' '{' body += function_item+ '}'
	| template_instantiation; // See Syntax 65, 9.1
function_item:
	all_purpose_item
	| behavior
	| structure
	| statetable;

test:
	'TEST' '{' body += test_item+ '}'
	| template_instantiation; // See Syntax 66, 9.2
test_item: all_purpose_item | behavior | statetable;

pin_value:
	pin_variable = identifier
	| Boolean_value; // See Syntax 67, 9.3.1
pin_assignment:
	pin_variable = identifier '=' value = pin_value ';'; // See Syntax 68, 9.3.2
behavior:
	'BEHAVIOR' '{' behavior_item+ '}'
	| template_instantiation; // See Syntax 69, 9.4
behavior_item:
	boolean_assignment
	| control_statement
	| primitive_instantiation
	| template_instantiation;
boolean_assignment:
	pin_variable = identifier '=' boolean_expression ';';
control_statement:
	primary_control_statement alternative_control_statement*;
primary_control_statement:
	'@' control_expression '{' boolean_assignment+ '}';
alternative_control_statement:
	':' control_expression '{' boolean_assignment+ '}';
primitive_instantiation:
	identifier identifier? '{' pin_value+ '}'
	| identifier identifier? '{' boolean_assignment+ '}';
structure:
	'STRUCTURE' '{' cell_instantiation+ '}'
	| template_instantiation; // See Syntax 70, 9.5
cell_reference_identifier: identifier;
cell_instantiation:
	cell_reference_identifier identifier ';'
	| cell_reference_identifier identifier '{' pin_value* '}'
	| cell_reference_identifier identifier '{' pin_assignment* '}'
	| template_instantiation;
cell_instance_pin_assignment:
	pin_variable = identifier '=' pin_value ';';
statetable:
	'STATETABLE' id = identifier? '{' tableheader = statetable_header rows += statetable_row+ '}'
	| template_instantiation; // See Syntax 71, 9.6
statetable_header:
	inputs += identifier+ ':' outputs += identifier+ ';';
statetable_row:
	control_values += statetable_control_value+ ':' data_values += statetable_data_value+ ';';
statetable_control_value:
	Boolean_value
	| Symbolic_bit_literal
	| edge_value;
statetable_data_value:
	Boolean_value
	| '(' ('!')? input_pin = identifier ')'
	| '(' ('~')? input_pin = identifier ')';

non_scan_cell:
	'NON_SCAN_CELL' '=' references += non_scan_cell_reference ';'
	| 'NON_SCAN_CELL' '{' references += non_scan_cell_reference+ '}'
	| template_instantiation; // See Syntax 72, 9.7
non_scan_cell_reference:
	id = identifier '{' scan_cell_pins += identifier '}'
	| id = identifier '{' (
		non_scan_cell_pins += identifier '=' scan_cell_pins += identifier ';'
	)* '}';

range:
	'RANGE' '{' from_index = index_value ':' until_index = index_value '}'; // See Syntax 73, 9.8

boolean_expression:
	'(' inner = boolean_expression ')'
	| val = Boolean_value
	| ref = identifier
	| unary = boolean_unary_operator right = boolean_expression
	| left = boolean_expression binary = boolean_binary_operator right = boolean_expression
	| condition = boolean_expression '?' then = boolean_expression ':' otherwise =
		boolean_expression; // See Syntax 74, 9.9

boolean_unary_operator:
	LogicNot
	| Not
	| And
	| NotAnd
	| Or
	| NotOr
	| Xor
	| NotXor;
boolean_binary_operator:
	| And
	| LogicAnd
	| NotAnd
	| Or
	| LogicOr
	| NotOr
	| Xor
	| NotXor
	| relational_operator
	| arithmetic_operator
	| shift_operator;

vector_expression:
	'(' inner = vector_expression ')'
	| event = single_event
	| left = vector_expression op = vector_operator right = vector_expression
	| condition = boolean_expression '?' then = vector_expression ':' otherwise = vector_expression
	| boolean_expression Control_and vector_expression
	| vector_expression Control_and boolean_expression
	| Vector_expression_macro; // See Syntax 75, 9.12

single_event: edge_literal boolean_expression;
vector_operator: event_operator | Event_and | Event_or;
Event_and: And | LogicAnd;
Event_or: Or | LogicOr;
Control_and: And | LogicAnd;

control_expression:
	'(' vector_expression ')'
	| '(' boolean_expression ')';

wire_instantiation:
	wire_reference = identifier wire_instance = identifier (
		';'
		| '{' values += pin_value* '}'
		| '{' assignments += pin_assignment* '}'
	)
	| template_instantiation; // See Syntax 76, 9.15
wire_instance_pin_assignment:
	wire_reference_pin = identifier '=' wire_instance = pin_value ';';

geometric_model:
	Non_escaped_identifier id = identifier? '{' body += geometric_model_item+ '}'
	| template_instantiation; // See Syntax 77, 9.16
geometric_model_item:
	point_to_point = single_value_annotation
	| coordinates;

coordinates: 'COORDINATES' '{' points += point+ '}';

point: x = Number y = Number;

geometric_transformation:
	shift
	| rotate
	| flip
	| repeat; // See Syntax 78, 9.18
shift: 'SHIFT' '{' x = Number y = Number '}';
rotate: 'ROTATE' '=' Number ';';
flip: 'FLIP' '=' Number ';';
repeat:
	'REPEAT' ('=' times += Unsigned_integer)* '{' transforms += geometric_transformation+ '}';

artwork:
	'ARTWORK' (
		'=' id = identifier ';'
		| '=' references += artwork_reference
		| '{' references += artwork_reference+ '}'
	)
	| template_instantiation; // See Syntax 79, 9.19

artwork_reference:
	id = identifier '{' transforms += geometric_transformation* (
		cell_pins += identifier*
		| (
			artwork_pin += identifier '=' cell_pins += identifier ';'
		)*
	) '}';
instance_identifier: identifier;
via_instantiation:
	id = identifier instance = identifier (
		';'
		| '{' transforms += geometric_transformation* '}'
	); // See Syntax 80, 9.20

arithmetic_expression:
	'(' inner = arithmetic_expression ')'
	| val = arithmetic_value
	| ref = identifier
	| condition = boolean_expression '?' then = arithmetic_expression ':' otherwise =
		arithmetic_expression
	| unary = ('+' | '-') right = arithmetic_expression
	| left = arithmetic_expression binary = arithmetic_operator right = arithmetic_expression
	| marco = macro_arithmetic_operator '(' macro_args += arithmetic_expression (
		',' macro_args += arithmetic_expression
	)* ')'; // See Syntax 81, 10.1
Abs: 'abs';
Exp: 'exp';
Log: 'log';
Min: 'min';
Max: 'max';
macro_arithmetic_operator: Abs | Exp | Log | Min | Max;

arithmetic_model:
	trivial_arithmetic_model
	| partial_arithmetic_model
	| full_arithmetic_model
	| template_instantiation; // See Syntax 82, 10.3
trivial_arithmetic_model:
	arithmetic_ref = identifier name = identifier? '=' value = arithmetic_value (
		';'
		| '{' qualifiers += arithmetic_model_qualifier* '}'
	); // See Syntax 83, 10.3

partial_arithmetic_model:
	arithmetic_ref = identifier name = identifier? '{' body += partial_arithmetic_model_item* '}';
// See Syntax 84, 10.3

partial_arithmetic_model_item:
	arithmetic_model_qualifier
	| table
	| trivial_min_max;
full_arithmetic_model:
	arithmetic_ref = identifier name = identifier? '{' qualifiers += arithmetic_model_qualifier*
		body = arithmetic_model_body qualifiers += arithmetic_model_qualifier* '}';
// See Syntax 85, 10.3

arithmetic_model_body:
	header_table_equation trivial_min_max?
	| min_typ_max
	| arithmetic_submodel+; // See Syntax 86, 10.3
arithmetic_model_qualifier:
	inheritable_arithmetic_model_qualifier
	| non_inheritable_arithmetic_model_qualifier; // See Syntax 87, 10.3
inheritable_arithmetic_model_qualifier:
	annotation
	| annotation_container
	| from_to;
non_inheritable_arithmetic_model_qualifier:
	auxiliary_arithmetic_model
	| violation;
header_table_equation:
	header (table | equation); // See Syntax 88, 10.4

header:
	'HEADER' '{' header_arithmetic_model+ '}'; // See Syntax 89, 10.4
header_arithmetic_model:
	arithmetic_ref = identifier name = identifier? '{' body += header_arithmetic_model_item* '}';
header_arithmetic_model_item:
	inheritable_arithmetic_model_qualifier
	| table
	| trivial_min_max;

equation:
	'EQUATION' '{' arithmetic_expression '}'
	| template_instantiation; // See Syntax 90, 10.4

table: 'TABLE' '{' arithmetic_value+ '}';
min_typ_max: min_max | min? typ max?; // See Syntax 92, 10.5
min_max: min | max | min max;
min: trivial_min | non_trivial_min;
max: trivial_max | non_trivial_max;
typ: trivial_typ | non_trivial_typ;
non_trivial_min:
	'MIN' '=' val = arithmetic_value '{' violations = violation '}'
	| 'MIN' '{' violations = violation? table_equation = header_table_equation '}';
// See Syntax 93, 10.5
non_trivial_max:
	'MAX' '=' val = arithmetic_value '{' violations = violation '}'
	| 'MAX' '{' violations = violation? table_equation = header_table_equation '}';
non_trivial_typ:
	'TYP' '{' table_equation = header_table_equation '}';
trivial_min_max:
	trivial_min // See Syntax 94, 10.5
	| trivial_max
	| trivial_min trivial_max;
trivial_min: 'MIN' '=' val = arithmetic_value ';';
trivial_max: 'MAX' '=' val = arithmetic_value ';';
trivial_typ: 'TYP' '=' val = arithmetic_value ';';
auxiliary_arithmetic_model:
	arithmetic_ref = identifier '=' val = arithmetic_value ';'
	| arithmetic_ref = identifier ('=' val = arithmetic_value)? '{' qualifiers +=
		inheritable_arithmetic_model_qualifier+ '}'; // See Syntax 95, 10.6

arithmetic_submodel:
	sumodel = identifier (
		'=' val = arithmetic_value ';'
		| '{' violation? min_max '}'
		| '{' header_table_equation ( trivial_min_max)? '}'
		| '{' min_typ_max '}'
	)
	| template_instantiation; // See Syntax 96, 10.7

arithmetic_model_container:
	limit_arithmetic_model_container
	| early_late_arithmetic_model_container
	| container = identifier '{' arithmetic_model+ '}'; // See Syntax 97, 10.8.1

limit_arithmetic_model_container:
	'LIMIT' '{' limit_arithmetic_model+ '}'; // See Syntax 98, 10.8.2
limit_arithmetic_model:
	arithmetic_ref = identifier name = identifier? '{' qualifiers += arithmetic_model_qualifier*
		body = limit_arithmetic_model_body '}';
limit_arithmetic_model_body:
	submodels += limit_arithmetic_submodel+
	| min_max;
limit_arithmetic_submodel:
	submodel = identifier '{' violation? min_max '}';

early_late_arithmetic_model_container:
	early_arithmetic_model_container late_arithmetic_model_container?
	| late_arithmetic_model_container; // See Syntax 99, 10.8.3
early_arithmetic_model_container:
	'EARLY' '{' arithmetic_model+ '}';
late_arithmetic_model_container:
	'LATE' '{' arithmetic_model+ '}';
// early_late_arithmetic_model: delay = arithmetic_model | retain = arithmetic_model | slewrate =
// arithmetic_model;

violation:
	'VIOLATION' '{' body += violation_item+ '}'
	| template_instantiation; // See Syntax 100, 10.10
violation_item:
	message_type = single_value_annotation
	| message = single_value_annotation
	| behavior;

from_to: from to? | to; // See Syntax 101, 10.12
from: 'FROM' '{' body += from_to_item+ '}';
to: 'TO' '{' body += from_to_item+ '}';
from_to_item:
	pin_reference = single_value_annotation
	| edge_number = single_value_annotation
	| threshold = arithmetic_model;
