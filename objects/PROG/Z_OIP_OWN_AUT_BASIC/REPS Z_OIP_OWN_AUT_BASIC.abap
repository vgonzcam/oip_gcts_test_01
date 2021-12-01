*&---------------------------------------------------------------------*
*& Report Z_OIP_OWN_AUT_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* ALL IN
REPORT z_oip_own_aut_basic.

*
CLASS lcl_sum DEFINITION.
  PUBLIC SECTION.
    METHODS: sum IMPORTING iv_1 TYPE i
                 RETURNING VALUE(rv_sum) TYPE i,
             sub IMPORTING iv_1 TYPE i
                 RETURNING VALUE(rv_sum) TYPE i.
ENDCLASS.                    "lcl_sum DEFINITION
*
START-OF-SELECTION.
* Nothing here yet
*
*
CLASS lcl_sum IMPLEMENTATION.
  METHOD sum.
    rv_sum = iv_1 + iv_1.
  ENDMETHOD.                    "sum

    METHOD sub.
    rv_sum = iv_1 - iv_1.
  ENDMETHOD.
ENDCLASS.                    "lcl_sum IMPLEMENTATION

*
CLASS lcl_test DEFINITION FOR TESTING
  "#AU Risk_Level Harmless
  "#AU Duration   Short
.
  PUBLIC SECTION.
    METHODS: m_sum FOR TESTING,
             m_sub FOR TESTING.
endclass.                    "lcl_test DEFINITION
*
CLASS lcl_test IMPLEMENTATION.

  METHOD m_sum.

    DATA: o_cut TYPE REF TO lcl_sum.
    DATA: lv_result TYPE i.
*
    CREATE OBJECT o_cut.
    lv_result = o_cut->sum( 3 ).
*
    cl_aunit_assert=>assert_equals(
        exp                  = 6
        act                  = lv_result
        msg                  = 'OK'
           ).
*
    cl_aunit_assert=>assert_equals(
        exp                  = 7
        act                  = lv_result
        msg                  = 'KO'
           ).

  ENDMETHOD.                    "m_sum

  METHOD m_sub.

    DATA: o_cut TYPE REF TO lcl_sum.
    DATA: lv_result TYPE i.
*
    CREATE OBJECT o_cut.
    lv_result = o_cut->sub( 3 ).
*
    cl_aunit_assert=>assert_equals(
        exp                  = 0
        act                  = lv_result
        msg                  = 'OK'
           ).
*
    cl_aunit_assert=>assert_equals(
        exp                  = 1
        act                  = lv_result
        msg                  = 'KO'
           ).

  ENDMETHOD.
ENDCLASS.                    "lcl_test IMPLEMENTATION