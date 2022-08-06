<html>
<?php

$conn = OCILogon("ora_rsinha01", "a59501783", "dbhost.students.cs.ubc.ca:1522/stu");

if (!$conn) {

$error = OCI_Error();
trigger_error(htmlentities($error['message']))

    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);



}














</html>





<?php
    $db = "(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.34)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))" ;

    if($c = OCILogon("system", "your database password", $db))
    {
        echo "Successfully connected to Oracle.\n";
        OCILogoff($c);
    }
    else
    {
        $err = OCIError();
        echo "Connection failed." . $err[text];
    }
?>