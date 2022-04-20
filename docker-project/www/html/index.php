

<form action="upload.php" method='post' enctype="multipart/form-data">
<input type="file" name="file"/><br><br>
Upload to Which Folder:<input type="text" name="where"/>//Uploads or Documents Folder<br><br>
  
  <p>Choose the file type :</p>

  <input type="radio" id="asterisk" name="logtyp" value="asterisk">
  <label for="asterisk">asterisk</label>

  <input type="radio" id="xuc" name="logtyp" value="xuc">
  <label for="xuc">xuc</label>

  <input type="radio" id="access" name="logtyp" value="access">
  <label for="access">access</label>

  <br><br>
  Password:<input type="password" name="password"/>
  <input type="submit" value="Upload"/>
</form>