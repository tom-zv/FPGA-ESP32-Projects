<!DOCTYPE html>
<html lang="en">
<body>
  <p>
    Implementation of an IR receiver, capable of decoding manchester encoded
    messages. Used to study the encoding used by my AC & compare and verify the
    signals sent by my implementation of the IR remote.
    control over ESP32 (RX/TX commands) is realised by a TCP socket server.
  </p>
  <h1>decoding process</h1>
  <p> 
    Utilizing the ESP-IDF framework and its RMT component, this implementation decodes a captured mark-space array as a manchester encoded signal.
    By analysing different commands sent from an AC remote, the signals structure can be reconstructed, as well as the underlying command`s bit-structure.
    Based on such an analysis, I wrote an encoder which converts AC settings to the appropriate signal, formatted for transmission by the RMT component.
    This project provided a practical application of embedded programming, working within an established framework, as well as providing insight into signal analysis & IR communication.</p>
</body>
</html>
