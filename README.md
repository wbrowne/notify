<p align="center">
  <img src="logo.png" width="400">
</p>

Notify is a (very stupid) ruby script that will periodically visit a web page and notify you based on changing web content which you specify.

For example - you would like to know when a certain product page no longer displays the text "Not in stock". 
IE you want a Logitech camera and don't want to spend all your free time refreshing the product page.

```json
{
  "url": "https://www.logitech.com/de-de/product/hd-pro-webcam-c920s",
  "criteria": {
    "js_selector": "#section-product-hero > div.container.product-hero-container-top.js-productContainerTop > div.product-details-ctn.js-productDetailsCtn > div > div.product-details-block.cart.buyAtPartner.black > div > p.product-hero-availability-message",
    "match": {
      "condition": "ne",
      "text": "Nicht auf Lager"
    }
  },
  "interval": 60
},
...
```

## Installation

(only macOS currently)

- Install [chromedriver](https://chromedriver.chromium.org/)
- Fetch dependencies:

```bash
bundle install
```

## Usage

```bash
ruby ./main.rb watch config.json
```

```json
{
  "url": "https://www.logitech.com/de-de/product/hd-pro-webcam-c920s",
  "criteria": {
    "js_selector": "#section-product-hero > div.container.product-hero-container-top.js-productContainerTop > div.product-details-ctn.js-productDetailsCtn > div > div.product-details-block.cart.buyAtPartner.black > div > p.product-hero-availability-message",
    "match": {
      "condition": "ne",
      "text": "Nicht auf Lager"
    }
  },
  "interval": 60,
  "notification": {
    "name": "Logitech webcam stock check",
    "from": "watcher@noti.fy",
    "to": "desperateforalogitechwebcam@gmail.com",
    "redirect": "https://www.logitech.com/de-de/product/hd-pro-webcam-c920s",
    "server": {
      "address": "smtp.notify.com",
      "port": 587,
      "domain": "mail.notify.com",
      "username": "watcher@noti.fy",
      "password": "$up@S3cu]Ur3"
    }
  }
}
```

Command helper:
```bash
ruby ./main.rb help 
```
