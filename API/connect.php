<?php
$username = "truyenbo";
$password = "Truyenbo99";
$host = "localhost";
$database = "shop_noi_that";

$conn = new mysqli($host, $username, $password, $database);
// Change character set to utf8
$conn->set_charset("utf8");

?>