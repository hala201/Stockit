<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "Portfolio" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

<html>
<head>
    <title>Investment Portfolio</title>
</head>

<body>
<h2 style="text-align: center;">Reset</h2>
<p style="text-align: center;">If you wish to reset the table press on the reset button. If this is the first time you're running this page, you MUST use reset</p>

<form method="POST" action="portfolio.php" style="text-align: center;">
    <!-- if you want another page to load after the button is clicked, you have to specify that page in the action parameter -->
    <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
    <p><input type="submit" value="Reset" name="reset"></p>
</form>

<hr />

<h2 style="text-align: center;">Insert Values into Portfolio</h2>
<form method="POST" action="portfolio.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
    ID: <input type="text" name="id" placeholder ="ID"> <br /><br />
    Net Worth: <input type="text" name="networth" placeholder ="Net Worth"> <br /><br />
    Email ID: <input type="text" name="email" placeholder ="Email ID"> <br /><br />

    <input type="submit" value="Insert" name="insertSubmit"></p>
</form>

<hr />

<h2 style="text-align: center;">Update Name in Portfolio</h2>
<p style="text-align: center;">The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>

<form method="POST" action="portfolio.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
    Old Net Worth: <input type="text" name="oldNetworth" placeholder ="Old Net Worth"> <br /><br />
    New Net Worth: <input type="text" name="newNetworth" placeholder ="New Net Worth"> <br /><br />

    <input type="submit" value="Update" name="updateSubmit"></p>
</form>
<!-- 
    SELECTION
Create one query of this category and provide an interface
for the user to specify the values of the selection
conditions to be returned. Example:
SELECT ...
FROM ...
WHERE Field1 = :Var1 AND Field2 > :Var20 = Incorrect or missing
-->

<hr />

<h2 style="text-align: center;">Choose a Real Estate</h2>
<p style="text-align: center;">There are 5 available real estates to add to your portfolio</p>

<form method="GET" action="portfolio.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="selectQueryRequest" name="selectQueryRequest">
    min Buy Price: <input type="text" name="minPrice" placeholder ="minPrice"> <br /><br />
    Max Buy Price: <input type="text" name="maxPrice" placeholder ="maxPrice"> <br /><br />

    <input type="submit" value="select" name="selectSubmit"></p>
</form>

<hr />

<h2 style="text-align: center;">Count the Tuples in Portfolio</h2>
<form method="GET" action="portfolio.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="countTupleRequest" name="countTupleRequest">
    <input type="submit" name="countTuples"></p>
</form>





<?php
//this tells the system that it's no longer just parsing html; it's now parsing PHP

$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = NULL; // edit the login credentials in connectToDB()
$show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

function debugAlertMessage($message) {
    global $show_debug_alert_messages;

    if ($show_debug_alert_messages) {
        echo "<script type='text/javascript'>alert('" . $message . "');</script>";
    }
}

function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
    //echo "<br>running ".$cmdstr."<br>";
    global $db_conn, $success;

    $statement = OCIParse($db_conn, $cmdstr);
    //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
        echo htmlentities($e['message']);
        $success = False;
    }

    $r = OCIExecute($statement, OCI_DEFAULT);
    if (!$r) {
        echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
        $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
        echo htmlentities($e['message']);
        $success = False;
    }

    return $statement;
}

function executeBoundSQL($cmdstr, $list) {
    /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
In this case you don't need to create the statement several times. Bound variables cause a statement to only be
parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
See the sample code below for how this function is used */

    global $db_conn, $success;
    $statement = OCIParse($db_conn, $cmdstr);

    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn);
        echo htmlentities($e['message']);
        $success = False;
    }

    foreach ($list as $tuple) {
        foreach ($tuple as $bind => $val) {
            //echo $val;
            //echo "<br>".$bind."<br>";
            OCIBindByName($statement, $bind, $val);
            unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
        }

        $r = OCIExecute($statement, OCI_DEFAULT);
        if (!$r) {
            echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
            echo htmlentities($e['message']);
            echo "<br>";
            $success = False;
        }
    }
}

function printRealEstateResult($result) { //prints results from a select statement
    echo "<br>Retrieved data from table Portfolio:<br>";
    echo "<table>";
    echo "<tr><th>ID</th><th>Name</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        echo "<tr><td>" . $row["Address_"] . "</td><td>" . $row["BuyPrice"] . "</td></tr>" . $row["Value_"] . "</td></tr>" . $row["Type_"] . "</td></tr>" . $row["ID"] . "</td></tr>"; //or just use "echo $row[0]"
    }

    echo "</table>";
}

function connectToDB() {
    global $db_conn;

    // Your username is ora_(CWL_ID) and the password is a(student number). For example,
    // ora_platypus is the username and a12345678 is the password.
    $db_conn = OCILogon("ora_hmurad01", "a66208828", "dbhost.students.cs.ubc.ca:1522/stu");

    if ($db_conn) {
        debugAlertMessage("Database is Connected");
        return true;
    } else {
        debugAlertMessage("Cannot connect to Database");
        $e = OCI_Error(); // For OCILogon errors pass no handle
        echo htmlentities($e['message']);
        return false;
    }
}

function disconnectFromDB() {
    global $db_conn;

    debugAlertMessage("Disconnect from Database");
    OCILogoff($db_conn);
}

function handleUpdateRequest() {
    global $db_conn;

    $old_networth = $_POST['oldNetworth'];
    $new_networth = $_POST['newNetworth'];

    // you need the wrap the old name and new name values with single quotations
    executePlainSQL("UPDATE Portfolio SET NetWorth='" . $new_networth . "' WHERE NetWorth='" . $old_networth . "'");
    OCICommit($db_conn);
}

function handleResetRequest() {
    global $db_conn;
    $sql = file_get_contents('stocks.sql');
    $delimiter = ';';
    $commands = explode($delimiter, $sql);
    foreach ($commands as $command) {
        executePlainSQL($command);
    }   
    OCICommit($db_conn);
}

function handleInsertRequest() {
    global $db_conn;

    //Getting the values from user and insert data into the table
    $tuple = array (
        ":bind1" => $_POST['id'],
        ":bind2" => $_POST['networth'],
        ":bind3" => $_POST['email']
    );

    $alltuples = array (
        $tuple
    );

    executeBoundSQL("INSERT INTO Portfolio VALUES (:bind1, :bind2, :bind3)", $alltuples);
    OCICommit($db_conn);
}

function handleCountRequest() {
    global $db_conn;

    $result = executePlainSQL("SELECT Count(*) FROM Portfolio");

    if (($row = oci_fetch_row($result)) != false) {
        echo "<br> The number of tuples in Portfolio: " . $row[0] . "<br>";
    }
}

function handleSelectRequest(){
    global $db_conn;
    $min_price = $_GET['minPrice'];
    $max_price = $_GET['maxPrice'];

    $result = executeSQL("SELECT * 
                            FROM RealEstate
                            WHERE BuyPrice >='" . $min_price . "' AND BuyPrice =<' " . $max_price . "'");
    echo "<br>Retrieved data from table Portfolio:<br>";
    echo "<table>";
    echo "<tr><th>Address_</th><th>BuyPrice</th></tr>Value_</th></tr>Type_</th></tr>ID</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        echo "<tr><td>" . $row["Address_"] . "</td><td>" . $row["BuyPrice"] . "</td></tr>" . $row["Value_"] . "</td></tr>" . $row["Type_"] . "</td></tr>" . $row["ID"] . "</td></tr>"; //or just use "echo $row[0]"
    }

    echo "</table>";
    
        //echo "<br> The following rows match your search: " . $selection . "<br>";
    OCICommit($db_conn);
}

// HANDLE ALL POST ROUTES
// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
function handlePOSTRequest() {
    if (connectToDB()) {
        if (array_key_exists('resetTablesRequest', $_POST)) {
            handleResetRequest();
        } else if (array_key_exists('updateQueryRequest', $_POST)) {
            handleUpdateRequest();
        } else if (array_key_exists('insertQueryRequest', $_POST)) {
            handleInsertRequest();
        } 

        disconnectFromDB();
    }
}

// HANDLE ALL GET ROUTES
// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
function handleGETRequest() {
    if (connectToDB()) {
        if (array_key_exists('countTuples', $_GET)) {
            handleCountRequest();
        } else if (arrar_key_exists('selectQueryRequest', $_GET)) {
            handleSelectRequest();
        }
        disconnectFromDB();
    }
}

if (isset($_POST['reset']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit'])) {
    handlePOSTRequest();
} else if (isset($_GET['countTupleRequest']) || isset($_GET['selectSubmit'])) {
    handleGETRequest();
}
?>
</body>
</html>
