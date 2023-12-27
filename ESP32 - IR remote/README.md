<!DOCTYPE html>
<html lang="en">
<body>
  <h1>ESP32 IR remote</h1>
  <p>IR remote implemented using the ESP32 RMT component, controlled by a webserver running on the ESP. </p>
  <br>
  <p align="center"> 
    <img width=300 height=235 src="https://github.com/tom-zv/FPGA-ESP32-Projects/assets/96687713/9c52fccc-1e1a-4177-b196-013618267c74">
  </p>
  <h2>Frontend</h2>
  <p>
  - Web-browser client, gaining a solid understanding of HTML, CSS, and JavaScript.<br>
  - Android app, developed using Kotlin and Android Jetpack Compose.<br>
  <br>
  Creating frontends for the AC remote provided hands-on experience in UI/UX design as well as an understanding of frontend and backend interoperability considerations.<br><br>
</p>
  <table align="center">
  <tr>
    <td><img width="152" height="334" src="https://github.com/tom-zv/FPGA-ESP32-Projects/assets/96687713/3f11c88d-5c0c-4fc3-bf93-97b606d21df8"></td>
    <td><img width="152" height="334" src="https://github.com/tom-zv/FPGA-ESP32-Projects/assets/96687713/ef37c248-d378-4ed8-b5b2-81fff8eb9859"></td>
    <td><img width="224" height="376" src="https://github.com/tom-zv/FPGA-ESP32-Projects/assets/96687713/c7ad3d25-0176-4fe8-b7a5-5eba6871e56c"></td>
  </tr>
  <tr>
     <td align="center"> AC Controller App</td>
     <td align="center"> Schedule page</td>
      <td align="center"> Upload webpage
     <br>
     <p>allows OTA webpage updates</p></td>
  </tr>
 </table>
  </p>
 <h2>Backend</h2>
 <p> The backend uses the ESP-IDF framework for its https server implementation & Remote Control Transciever (RMT) component, running on an ESP-WROOM-32 Devkit.<br>
     This project provided valuable experience in working within an established framework and interfacing with its APIs.<br>
     Additionally, it involved practical application of operating system features, such as synchronization mechanisms with semaphores and mutexes, interprocess communication using FreeRTOS task notifications, and employing timers to coordinate task sleep states.
 </p>
</body>
</html>
