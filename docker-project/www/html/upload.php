<?php 

$name= $_FILES['file']['name'];

$tmp_name= $_FILES['file']['tmp_name'];

$submitbutton= $_POST['submit'];

$where_to_upload= $_POST['where'];

$where_to_upload= str_replace(" ", "", $where_to_upload);

$password1= $_POST['password'];

$password2= "Avencall2022"; //change this to the password you want 

if (isset($_POST['logtyp'])){   
  $logtype= $_POST['logtyp'];
}
else{
    echo "Le type du fichier n'as pas été selectionné";
}

$length= strlen($where_to_upload);

$last= substr($where_to_upload, $length-1, 1);
if ($last !== "/"){
$where_to_upload= "$where_to_upload" . "/";
}

$first= substr($where_to_upload, 0, 1);
if ($first == "/"){
$where_to_upload= str_replace("/", "", $where_to_upload);
}

$name = "$logtype" . "-" . "$name";

if (isset($name)) {
    if (empty($name))
        {
        echo "Please choose a file";
        }
    else if ((!empty($name)) && ($password1 == $password2))
        {
            
        if (move_uploaded_file($tmp_name, $where_to_upload . $name)) {
        echo "Uploaded!";
        }
        }
    else
    {
    echo "The password entered is incorrect. The upload has not been done.";
    }
}

if  ((!empty($name)) && ($password1 == $password2)){
echo "The file you uploaded is shown below.<br><br>";
echo "<a href='$where_to_upload" ."$name'>$name</a>";
echo "<br><br>";
echo "<a href=https://support-tools.avencall.com/elksupport/kibana/>Explore Kibana</a>";
echo "<br><br>";
}
?>

