# Jacaranda [Depreciated because this Right To Know version has been incorporated into [the original version](https://github.com/openaustralia/jacaranda)]

*A watchful tree and slack messenger to keep you informed of the use of Right To Know.*

Jacaranda is an experiment to see the impact of regular feedback
on the people developing and contributing to Right To Know.
It aims to keep you more informed of the use and impact of Right To Know;
to remind you of the effort you’ve put in to achieve this; and to do this in an
quick and unobtrusive way.

Jacaranda collects information about what’s happening on Right To Know and
the work contributors do to make it better for them.
It then sends a short fortnightly message to our Slack channel
to give us a sense of how things are going.

![Image of slack message from Jacaranda](screenshot.jpg)

This is a very basic start.
We’ve interested to see how getting these messages impacts us
and what we do with the information.

Currently Jacaranda tells you about:

* The number of new requests in the last fortnight
* The number of annotations in the last fortnight
* The number of requests that were successful in the last fortnight

Feel free to change the text or the information in presents to what you think
will have a better impact.

## Usage

This program depends on three environment variables:

* *Slack channel webhook url* to post the message to
* *Live mode* to make it actually post to the Slack channel #townsquare and save to the database

In local development you can add these to a `.env` file
and [use dotenv](https://github.com/bkeepers/dotenv) to load them as the scraper runs:

```
MORPH_SLACK_CHANNEL_WEBHOOK_URL="https://hooks.slack.com/services/XXXXXXXXXXXXX"
MORPH_LIVE_MODE=false
```

Create a `.env` file using the example provided by running `cp .env.example .env`.

### Running this on morph.io

You can also run this as a scraper on [Morph](https://morph.io).
To get started [see the documentation](https://morph.io/documentation)

## Image credit

The Jacaranda Slack avatar is cropped from a [photograph of the Jacaranda trees on
Gowrie St, Newtown, Sydney by Flickr user
murry](https://www.flickr.com/photos/hopeless128/15808564051/in/photolist-aCSCXw-q8S).
Thanks murry for making it available under a creative commons license.
