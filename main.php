<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

<html>
<head>
    <title>Investment Application</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

</head>

<body>
<h2 style="text-align: center;">Start-Session</h2>

<form method="POST" action="main.php" style="text-align: center;">
    <!-- if you want another page to load after the button is clicked, you have to specify that page in the action parameter -->
    <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
    <p><input type="submit" value="Reset" name="reset"></p>
</form>

<hr />

<div class="muButton" style="text-align: center;">
    <a href="./portfolio.php">
        <button class="portfolioButton" style="position:relative; left:19px;">
            <b class="thetext">go to your portfolio</b>
        </button>
    </a>
</div>


<h2 style="text-align: center;">Sign up</h2>
<form method="POST" action="main.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
    SIN: <input type="text" name="sin" placeholder ="SIN" style="position:relative; left:9px;"> <br /><br />
    Name: <input type="text" name="Name" placeholder ="Name"> <br /><br />
    Email: <input type="email" name="email" placeholder ="Email"> <br /><br />
    Age: <input type="date" name="dob" placeholder ="Age" placeholder ="SIN" style="position:relative; left:7px;width:12%;"> <br /><br />

    <input type="submit" value="Insert" name="insertSubmit"></p>
</form>

<hr />

<h2 style="text-align: center;">Edit your user information</h2>
<p style="text-align: center;">If you are a current user, you can update your email or name below. The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>


<style>
   body{

    background:url('<?php $a = array('milestone1.jpg', 'img2.jpg', 'img3.jpg'); echo $a[array_rand($a)];?>');
   }
    

    </style>



<form method="POST" action="main.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
    SIN: <input type="text" name="currentSIN" placeholder="SIN" placeholder ="SIN" style="position:relative; left:19px;"> <br /><br />
    Old Email: <input type="text" name="newEmail" placeholder ="Old Email"> <br /><br />
    New Email: <input type="text" name="newEmail" placeholder ="New Email"> <br /><br />
    Old Name: <input type="text" name="oldName" placeholder ="Old Name"> <br /><br />
    New Name: <input type="text" name="newName" placeholder ="New Name"> <br /><br />


    <input type="submit" value="Update" name="updateSubmit"></p>
</form>

<hr/>

<h2 style="text-align: center;">Unsubscribe From the Investment Application</h2>
<p style="text-align: center;">If you are a current user, you can delete your subscription</p>

<form method="POST" action="main.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
    Old Name: <input type="text" name="oldName" placeholder ="Old Name"> <br /><br />
    New Name: <input type="text" name="newName" placeholder = "New Name"> <br /><br />
    Old Email: <input type="text" name="newEmail" placeholder ="Old Email"> <br /><br />
    New Email: <input type="text" name="newEmail" placeholder = "New Email"> <br /><br />

    <input type="submit" value="Delete" name="deleteSubmit"></p>
</form>

<hr />
<h2 style="text-align: center;">Number of Current Users</h2>
<form method="GET" action="main.php" style="text-align: center;"> <!--refresh page when submitted-->
    <input type="hidden" id="countTupleRequest" name="countTupleRequest">
    <input type="submit" name="countTuples"></p>
</form>



<?php
//this tells the system that it's no longer just parsing html; it's now parsing PHP

$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = NULL; // edit the login credentials in connectToDB()
$show_debug_alert_messages = True; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())
$profpic = "milestone1.jpg";
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

function printResult($result) { //prints results from a select statement
    echo "<br>Retrieved data from table demoTable:<br>";
    echo "<table>";
    echo "<tr><th>ID</th><th>Name</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        echo "<tr><td>" . $row["ID"] . "</td><td>" . $row["NAME"] . "</td></tr>"; //or just use "echo $row[0]"
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

    $old_name = $_POST['oldName'];
    $new_name = $_POST['newName'];
    $old_email = $_POST['oldEmail'];
    $new_email = $_POST['newEmail'];
    $curr_sin = $_POST['currentSIN'];
    // you need the wrap the old name and new name values with single quotations
    executePlainSQL("UPDATE User_ SET Name_='" . $new_name . "' WHERE Name_='" . $old_name . "'");
   // executePlainSQL("UPDATE User_ SET Email='" . $new_email . "' WHERE EmailID='" . $old_email . "'");
    executePlainSQL("UPDATE User_ SET Email ='" . $new_email ."' WHERE SIN_ ='" . $curr_sin ."' AND EmailID='" . $old_email ."'");
    OCICommit($db_conn);
}

function handleDeleteRequest() {
    global $db_conn;

    $email = $_POST['Email'];
    $sin = $_POST['SIN'];
    // you need the wrap the old name and new name values with single quotations
    executePlainSQL("DELETE FROM User_ WHERE EmailID='" . $email . "' AND SIN_='" . $sin . "'");
    OCICommit($db_conn);
}
function handleResetRequest() {
    global $db_conn;
    $sql = trim(file_get_contents('stocks.sql'));
    // $block= <<<_SQL
    // BEGIN
    // $sql
    // END;
    // _SQL;
    // $stmt = oci_parse($db_conn, $block);
    // executePlainSQL($stmt);
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
        ":bind1" => $_POST['sin'],
        ":bind2" => $_POST['insName'],
        ":bind3" => $_POST[date('dob')],
        ":bind4" => $_POST['email']
    );

    $alltuples = array (
        $tuple
    );

    executeBoundSQL("insert into User_ values (:bind1, :bind2, :bind3, :bind4)", $alltuples);
    OCICommit($db_conn);
}

function handleCountRequest() {
    global $db_conn;

    $result = executePlainSQL("SELECT Count(*) FROM User_");

    if (($row = oci_fetch_row($result)) != false) {
        echo "<br> The number of users: " . $row[0] . "<br>";
    }
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
        } else if (array_key_exists('deleteQueryRequest', $_POST)) {
            handleDeleteRequest();
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
        }

        disconnectFromDB();
    }
}

if (isset($_POST['reset']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit']) || isset($_POST['deleteSubmit'])) {
    handlePOSTRequest();
} else if (isset($_GET['countTupleRequest'])) {
    handleGETRequest();
}
?>




</body>
</html>
