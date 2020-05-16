<p align="center">
  <img src="logo.png" width="400">
</p>

# Notify

Notify is a (very stupid) ruby script that will periodically watch a web page and notify you based on changing web content that you specify.

For example - you would like to know when a certain product page no longer displays the text "Not in stock". IE you want a Logitech camera and don't want to spend all your free time refreshing the product page.

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
}
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
ruby ./main.rb watch data.json
```

```json
{
  "url": "<Some valid URL to watch>",
  "criteria": {
    "js_selector": "<The specific element you want to watch>",
    "match": "<The string you DON't want to match against (poor naming I know - will fix)>"
  },
  "interval": 60
}
```

Command helper:
```bash
ruby ./main.rb help 
```
