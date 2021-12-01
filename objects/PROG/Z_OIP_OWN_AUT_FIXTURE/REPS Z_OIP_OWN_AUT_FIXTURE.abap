*&---------------------------------------------------------------------*
*& Report Z_OIP_OWN_AUT_FIXTURE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_OIP_OWN_AUT_FIXTURE.


*&---------------------------------------------------------------------*
*& Purpose - ABAP Unit fixture methods demo
*& Author  - Naimesh Patel
*& URL     - http://zevolving.com/?p=2228
*& URL     - http://zevolving.com/2013/05/abap-unit-test-fixture-methods/
*&---------------------------------------------------------------------*
*
CLASS lcl_data DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_data,
        glacc TYPE char10,
        dmbtr TYPE bseg-dmbtr,
      END OF ty_data.
    TYPES: tt_data TYPE STANDARD TABLE OF ty_data.
    DATA: t_data TYPE tt_data.
    METHODS: get_sum_for_glacc IMPORTING iv_glacc TYPE char10
             RETURNING VALUE(rv_amt) TYPE bseg-dmbtr.

ENDCLASS.                    "lcl_data DEFINITION

START-OF-SELECTION.

*
CLASS lcl_data IMPLEMENTATION.
  METHOD get_sum_for_glacc.
    DATA: ls_data LIKE LINE OF t_data.
    LOOP AT t_data INTO ls_data WHERE glacc = iv_glacc.
      rv_amt = rv_amt + ls_data-dmbtr.
    ENDLOOP.
  ENDMETHOD.                    "get_sum_for_glacc
ENDCLASS.                    "lcl_data IMPLEMENTATION
*
CLASS lcl_test_collect DEFINITION FOR TESTING
  "#AU Risk_Level Harmless
  "#AU Duration   Short
.
  PRIVATE SECTION.
    DATA: o_cut TYPE REF TO lcl_data.
    METHODS:
      setup,
      teardown,
      test_valid_gl   FOR TESTING,
      test_invalid_gl FOR TESTING.
ENDCLASS.                    "lcl_test_collect DEFINITION
*
CLASS lcl_test_collect IMPLEMENTATION.
  METHOD setup.
    DATA: ls_data LIKE LINE OF o_cut->t_data.
    CREATE OBJECT o_cut.
    ls_data-glacc = '101'. ls_data-dmbtr = '20'.
    APPEND ls_data TO o_cut->t_data.
    ls_data-glacc = '101'. ls_data-dmbtr = '30'.
    APPEND ls_data TO o_cut->t_data.
    ls_data-glacc = '102'. ls_data-dmbtr = '40'.
    APPEND ls_data TO o_cut->t_data.
    ls_data-glacc = '101'. ls_data-dmbtr = '50'.
    APPEND ls_data TO o_cut->t_data.
  ENDMETHOD.                    "setup
  METHOD teardown.
    CLEAR o_cut.
  ENDMETHOD.                    "teardown
  METHOD test_valid_gl.
    DATA: lv_result_amt TYPE bseg-dmbtr.
    lv_result_amt = o_cut->get_sum_for_glacc( '101' ).
    cl_aunit_assert=>assert_equals(
        EXP                  = 100
        act                  = lv_result_amt
        msg                  = 'Total is incorrect'
           ).
  ENDMETHOD.                    "test_valid_gl
  METHOD test_invalid_gl.
    DATA: lv_result_amt TYPE bseg-dmbtr.
    lv_result_amt = o_cut->get_sum_for_glacc( '999' ).
    cl_aunit_assert=>assert_equals(
        EXP                  = 0
        act                  = lv_result_amt
        msg                  = 'Total is incorrect'
           ).

  ENDMETHOD.                    "test_invalid_gl
ENDCLASS.                    "lcl_test_collect IMPLEMENTATION