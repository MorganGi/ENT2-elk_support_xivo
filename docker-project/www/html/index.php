
<style>
input[type=text], select {
  width: 25%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}
input[type=button], input[type=submit], input[type=reset] {
  background-color: #04AA6D;
  border: none;
  color: white;
  padding: 16px 32px;
  text-decoration: none;
  margin: 4px 2px;
  cursor: pointer;
}
</style>

<form action="upload.php" method='post' enctype="multipart/form-data">
<input type="file" name="file"/><br><br>
Upload to Which Folder:<input type="text" name="where" value="elkforxivo"/> //Ne pas modifier<br>
  
  <p>Choose the file type :</p>

  <input type="radio" id="asterisk" name="logtyp" value="asterisk">
  <label for="asterisk">asterisk</label>

  <input type="radio" id="xuc" name="logtyp" value="xuc">
  <label for="xuc">xuc</label>

  <input type="radio" id="access" name="logtyp" value="access">
  <label for="access">access</label>

  <input type="radio" id="xivo-authd" name="logtyp" value="xivo-authd">
  <label for="xivo-authd">xivo-authd</label>

  <input type="radio" id="xivo-ctid" name="logtyp" value="xivo-ctid">
  <label for="xivo-ctid">xivo-ctid</label>

  <input type="radio" id="xivo-confd" name="logtyp" value="xivo-confd">
  <label for="xivo-confd">xivo-confd</label>

  <br><br>
  Password:<input type="password" name="password"/>
  <br><br>
  <input type="submit" value="Upload"/><b> Attention le fichier ne doit pas dépasser 100MB</b>
</form>