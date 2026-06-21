METHOD if_oo_adt_classrun~main.
  DATA connections TYPE TABLE OF REF TO lcl_connection.
  DATA connection TYPE REF TO lcl_connection.

* First instance
  connection = NEW #( ).
  connection->carrier_id    = 'LH'.
  connection->connection_id = '0400'.
  APPEND connection TO connections.

* Second instance
  connection = NEW #( ).
  connection->carrier_id    = 'AA'.
  connection->connection_id = '0017'.
  APPEND connection TO connections.

* Third instance
  connection = NEW #( ).
  connection->carrier_id    = 'SQ'.
  connection->connection_id = '0001'.
  APPEND connection TO connections.
ENDMETHOD.
