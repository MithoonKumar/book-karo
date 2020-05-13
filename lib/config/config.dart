var devConfig = {
  "BASE_URL": "http://10.0.2.2:3000/",
  "GUPSHUP_URL": "https://enterprise.sharechat.com",
  "SEND_EVENT_PATH": "event"
};

var prodConfig = {
  "BASE_URL": "http://10.0.2.2:3000/",
  "GUPSHUP_URL": "https://enterprise.sharechat.com",
  "SEND_EVENT_PATH": "event"
};



class Config {
  dynamic config;

  Config () {
    String env = 'dev';
    final contents = env == 'dev' ? devConfig : prodConfig;
    this.config = contents;
  }
}