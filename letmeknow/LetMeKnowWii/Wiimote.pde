import processing.net.*;

/**
 * WiiFlash経由でWiiRemoteを使うためのライブラリ
 */
class Wiimote {
  Wiimote(PApplet applet) {
//       client = new Client(applet, "[::1]", 0x4A54);
    client = new Client(applet, "[::1]", 0x4A54);
  }
  /**
   * WiiRemoteからデータを取得します
   */
  void update() {
    boolean dataHasCome = false;
    while (client.available() > 80) {
      if (buffer == null) {
        buffer = new int[80];
      }
      for (int i = 0; i < 80; i++) {
        buffer[i] = client.read();
      }
      dataHasCome = true;
    }
    if (buffer == null || !dataHasCome) {
      return;
    }
    bufferPos = 1;
    batteryLevel = (float)readByte() / 0xC8;
    updateButtons(readShort());
    x = readFloat();
    y = readFloat();
    z = readFloat();
    extensionType = readByte();
  }
  
  /** 拡張タイプ */
  int extensionType;
  /** 各ボタン */
  Button one = new Button();
  Button two = new Button();
  Button a = new Button();
  Button b = new Button();
  Button plus = new Button();
  Button minus = new Button();
  Button home = new Button();
  Button up = new Button();
  Button down = new Button();
  Button left = new Button();
  Button right = new Button();
  /** バッテリーの残量 */
  float batteryLevel;
  /** 加速度 */
  float x, y, z;
  
  Client client;
  int[] buffer;
  int bufferPos;
  
  int readByte() {
    return buffer[bufferPos++];
  }
  int readShort() {
    return (buffer[bufferPos++] << 8) | buffer[bufferPos++];
  }
  float readFloat() {
    return Float.intBitsToFloat((buffer[bufferPos++] << 24)
        | (buffer[bufferPos++] << 16)
        | (buffer[bufferPos++] << 8)
        | buffer[bufferPos++]);
  }
  
  public void updateButtons(int state) {
    one.set(((state >> 15) & 1) != 0);
    two.set(((state >> 14) & 1) != 0);
    a.set(((state >> 13) & 1) != 0);
    b.set(((state >> 12) & 1) != 0);
    plus.set(((state >> 11) & 1) != 0);
    minus.set(((state >> 10) & 1) != 0);
    home.set(((state >> 9) & 1) != 0);
    up.set(((state >> 8) & 1) != 0);
    down.set(((state >> 7) & 1) != 0);
    right.set(((state >> 6) & 1) != 0);
    left.set(((state >> 5) & 1) != 0);
  }
  
  class Button {
    public boolean pressed;
    public boolean pushed;
    public void set(boolean value) {
      if (!pressed && !pushed && value) {
        pushed = true;
      } else {
        pushed = false;
      }
      pressed = value;
    }
  }
}
