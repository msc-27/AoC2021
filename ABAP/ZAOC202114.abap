REPORT ZAOC202114.
PARAMETERS file TYPE string DEFAULT 'C:\Windows\Temp\input' LOWER CASE OBLIGATORY.

CLASS cl_polymer DEFINITION.
PUBLIC SECTION.
  TYPES: element_t(1) TYPE c,
         pair_t(2)    TYPE c,
         count_t(11)  TYPE p DECIMALS 0.
  METHODS: constructor IMPORTING VALUE(polymer) TYPE string,
           add_rule IMPORTING pair TYPE pair_t
                              element TYPE element_t,
           evolve IMPORTING iterations TYPE i DEFAULT 1,
           evaluate RETURNING VALUE(diff) TYPE count_t.
PRIVATE SECTION.
  TYPES: BEGIN OF elt_count_t,
           element TYPE element_t,
           count   TYPE count_t,
         END OF elt_count_t,
         BEGIN of pair_count_t,
           pair  TYPE pair_t,
           count TYPE count_t,
         END OF pair_count_t,
         BEGIN OF mapping_t,
           pair    TYPE pair_t,
           element TYPE element_t,
         END OF mapping_t.
  DATA: elt_count TYPE HASHED TABLE OF elt_count_t
                       WITH UNIQUE KEY element
                       WITH NON-UNIQUE SORTED KEY count_key COMPONENTS count,
        pair_count TYPE HASHED TABLE OF pair_count_t
                        WITH UNIQUE KEY pair,
        mapping TYPE HASHED TABLE OF mapping_t
                     WITH UNIQUE KEY pair.
ENDCLASS.
CLASS cl_polymer IMPLEMENTATION.
  METHOD constructor.
    DATA(elt_entry) = VALUE elt_count_t( count = 1 ).
    DATA(pair_entry) = VALUE pair_count_t( count = 1 ).
    WHILE polymer IS NOT INITIAL.
      elt_entry-element = polymer(1). COLLECT elt_entry INTO elt_count.
      IF strlen( polymer ) > 1.
        pair_entry-pair = polymer(2). COLLECT pair_entry INTO pair_count.
      ENDIF.
      SHIFT polymer.
    ENDWHILE.
  ENDMETHOD.

  METHOD add_rule.
    INSERT VALUE mapping_t( pair = pair  element = element ) INTO TABLE mapping.
  ENDMETHOD.

  METHOD evolve.
    DATA new_pairs LIKE pair_count.
    DO iterations TIMES.
      LOOP AT pair_count INTO DATA(pair_entry).
        READ TABLE mapping WITH TABLE KEY pair = pair_entry-pair INTO DATA(map_entry).
        DATA(num) = pair_entry-count.
        DATA(elt) = map_entry-element.
        COLLECT VALUE elt_count_t( element = elt  count = num ) INTO elt_count.
        DATA(new_pair) = VALUE pair_count_t( count = num ).
        CONCATENATE pair_entry-pair(1) elt INTO new_pair-pair.
        COLLECT new_pair INTO new_pairs.
        CONCATENATE elt pair_entry-pair+1(1) INTO new_pair-pair.
        COLLECT new_pair INTO new_pairs.
      ENDLOOP.
    pair_count = new_pairs. CLEAR new_pairs.
    ENDDO.
  ENDMETHOD.

  METHOD evaluate.
    LOOP AT elt_count INTO DATA(elt_entry) USING KEY count_key.
      IF sy-tabix = 1. DATA(count_min) = elt_entry-count. ENDIF.
    ENDLOOP.
    diff = elt_entry-count - count_min.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

OPEN DATASET file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
IF sy-subrc <> 0. STOP. ENDIF.
DATA line TYPE string.
READ DATASET file INTO line. IF sy-subrc <> 0. STOP. ENDIF.
DATA(polymer) = NEW cl_polymer( line ).

READ DATASET file INTO line. IF sy-subrc <> 0. STOP. ENDIF.
DO.
  READ DATASET file INTO line. IF sy-subrc <> 0. EXIT. ENDIF.
  IF strlen( line ) < 7. STOP. ENDIF.
  DATA pair TYPE cl_polymer=>pair_t. pair = line(2).
  DATA element TYPE cl_polymer=>element_t. element = line+6(1).
  polymer->add_rule( pair = pair  element = element ).
ENDDO.

polymer->evolve( 10 ). WRITE   polymer->evaluate( ) NO-GROUPING.
polymer->evolve( 30 ). WRITE / polymer->evaluate( ) NO-GROUPING.
