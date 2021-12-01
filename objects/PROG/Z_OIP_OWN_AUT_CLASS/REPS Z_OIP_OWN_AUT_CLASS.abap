*&---------------------------------------------------------------------*
*& Report Z_OIP_OWN_AUT_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_oip_own_aut_class.

" https://www.codetd.com/en/article/12803038
" https://blogs.sap.com/2020/05/03/example-with-open-sql-test-double-framework/


CLASS zcl_system_clients DEFINITION
                         CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES clients   TYPE TABLE OF t000 WITH KEY mandt.
    TYPES languages TYPE TABLE OF t002 WITH KEY spras.

    METHODS get_client
      IMPORTING
        client        TYPE mandt
      RETURNING
        VALUE(result) TYPE clients.

    METHODS get_table_mock
      IMPORTING
        laiso         TYPE laiso
      RETURNING
        VALUE(result) TYPE languages.

    METHODS
      get_work_year IMPORTING i_date TYPE syst-datum
                    EXPORTING e_year TYPE dec10_2
                              e_msg  TYPE string.




ENDCLASS.

CLASS zcl_system_clients IMPLEMENTATION.
  METHOD get_client.
    SELECT * FROM t000 AS clients
             INTO TABLE result
             WHERE mandt = client.
  ENDMETHOD.

  METHOD get_table_mock.
    SELECT * FROM t002 AS language
             INTO TABLE result
             WHERE laiso = laiso.
  ENDMETHOD.

  METHOD get_work_year.
    IF i_date GT sy-datlo.
      MESSAGE e064(00) INTO e_msg.
    ELSE.
      e_year = ( sy-datlo - i_date ) / 365.
      e_year = round( val = e_year dec = 1 ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

CLASS ltc_test DEFINITION FINAL
               FOR TESTING
               DURATION SHORT
               RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS get_client_000 FOR TESTING.
    METHODS get_client_001 FOR TESTING.
    METHODS get_client_664_ok_ort FOR TESTING.
    METHODS get_client_665_bad_ort FOR TESTING.
    METHODS get_client_665_dump FOR TESTING.
    METHODS get_client_999 FOR TESTING.
    METHODS get_lanfu_es FOR TESTING.
    METHODS get_lanfu_xx FOR TESTING.
    METHODS ut_01_get_success_workyear FOR TESTING.
    METHODS ut_02_get_error_workyear FOR TESTING.

  PRIVATE SECTION.
    CLASS-DATA osql_test_environment TYPE REF TO if_osql_test_environment.
    DATA:      mo_cut                TYPE REF TO zcl_system_clients.
    DATA:      gv_hire_date          TYPE d.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS teardown.
    METHODS setup.

ENDCLASS.


CLASS ltc_test IMPLEMENTATION.
  METHOD class_setup.
    osql_test_environment = cl_osql_test_environment=>create( VALUE #( ( 'T000' ) ) ).
    DATA(clients_test_data) = VALUE zcl_system_clients=>clients( ( mandt = '000' mtext = 'Mock Data: Test double' ort01 = 'OK' )
                                                                 ( mandt = '001' mtext = 'Mock Data: Test double' ort01 = 'OK' )
                                                                 ( mandt = '664' mtext = 'Mock Data: Test double' ort01 = 'OK' )
                                                                 ( mandt = '665' mtext = 'Mock Data: Test double' ort01 = 'KO' )
                                                                 ( mandt = '999' mtext = 'Mock Data: Test double' ort01 = 'OK' ) ).
    osql_test_environment->insert_test_data( clients_test_data ).
  ENDMETHOD.

  METHOD class_teardown.
    osql_test_environment->destroy( ).

  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
    CLEAR gv_hire_date.
  ENDMETHOD.

  METHOD setup.

    mo_cut = NEW zcl_system_clients( ).
    gv_hire_date = '20000101'.

  ENDMETHOD.


  METHOD get_client_000.
    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '000' ).
    cl_aunit_assert=>assert_not_initial( result ).
  ENDMETHOD.

  METHOD get_client_001.
    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '001' ).
    cl_aunit_assert=>assert_not_initial( result ).
  ENDMETHOD.

  METHOD get_client_999.
    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '999' ).
    cl_aunit_assert=>assert_not_initial( result ).
  ENDMETHOD.

  METHOD get_client_664_OK_ort.

    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '664' ).
    cl_aunit_assert=>assert_not_initial( result ).

    " Verificacion de contenido...
    DATA lo_ex      TYPE REF TO cx_sy_itab_line_not_found.

    TRY.
        DATA(act) = result[ mandt = '664' ]-ort01.
      CATCH cx_sy_itab_line_not_found.
        cl_abap_unit_assert=>fail( lo_ex->get_text( ) ).
    ENDTRY.

    CALL METHOD cl_aunit_assert=>assert_equals
      EXPORTING
        exp = 'OK'
        act = act.

  ENDMETHOD.

  METHOD get_client_665_bad_ort.

    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '665' ).
    cl_aunit_assert=>assert_not_initial( result ).

    " Verificacion de contenido...
    DATA lo_ex      TYPE REF TO cx_sy_itab_line_not_found.

    TRY.
        DATA(act) = result[ mandt = '665' ]-ort01.
      CATCH cx_sy_itab_line_not_found.
        cl_abap_unit_assert=>fail( lo_ex->get_text( ) ).
    ENDTRY.

    CALL METHOD cl_aunit_assert=>assert_equals
      EXPORTING
        exp = 'OK'
        act = act
        msg = 'Error en la comparacion del campo T000-ORT1'.

  ENDMETHOD.

  METHOD get_client_665_dump.

    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_client( '665' ).
    cl_aunit_assert=>assert_not_initial( result ).

    TRY.
        DATA(act) = result[ mandt = '664' ]-ort01.
      CATCH cx_sy_itab_line_not_found.

        " Verificacion de contenido...
        " DATA lo_ex      TYPE REF TO cx_sy_itab_line_not_found.
        " data(msg) = lo_ex->get_text( ).
        " Se deja la opción por si se quiere enseñar el texto de la excepción...
        cl_abap_unit_assert=>fail( 'Excepción por mal coding en el TestUnit' ).
    ENDTRY.

    CALL METHOD cl_aunit_assert=>assert_equals
      EXPORTING
        exp = 'OK'
        act = act
        msg = 'Excepción por mal coding en el TestUnit'.

  ENDMETHOD.

  METHOD ut_01_get_success_workyear.

    gv_hire_date = '20150701'.

    mo_cut->get_work_year(
    EXPORTING
      i_date = gv_hire_date
    IMPORTING
      e_year = DATA(lv_year)
      e_msg = DATA(lv_msg)
    ).

    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act = lv_year
      exp = round( val = ( sy-datlo - gv_hire_date ) / 365 dec = 1  )
    ).

  ENDMETHOD.

  METHOD ut_02_get_error_workyear.
    DATA: lv_expect_msg TYPE string.

    mo_cut->get_work_year(
    EXPORTING
      i_date = gv_hire_date
    IMPORTING
    e_year = DATA(lv_year)
    e_msg = DATA(lv_msg)
          ).

    MESSAGE e064(00) INTO lv_expect_msg.
    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act = lv_msg
      exp = lv_expect_msg
      ).
  ENDMETHOD.


  METHOD get_lanfu_es.
    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_table_mock( 'ES' ).
    cl_aunit_assert=>assert_not_initial( result ).
  ENDMETHOD.

  METHOD get_lanfu_XX.
    DATA(cut) = NEW zcl_system_clients( ).
    DATA(result) = cut->get_table_mock( 'XX' ).

    CALL METHOD cl_aunit_assert=>assert_not_initial
      EXPORTING
        act              = result
        msg              = 'Error en la recuperación de BBDD'
        quit             = if_aunit_constants=>quit-no
      RECEIVING
        assertion_failed = DATA(assertion).

    IF assertion EQ abap_true.
      MESSAGE e888(sabapdemos) WITH 'Error en la recuperación. Mensaje condicional'.
    else.
    ENDIF.

  ENDMETHOD.


ENDCLASS.