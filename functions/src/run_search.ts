import * as functions from 'firebase-functions';
import * as got from 'got';

const credentials = functions.config().google;

export const runSearch = functions.https.onCall(async (data, context) => {
  try {
    const url = `https://www.googleapis.com/books/v1/volumes?key=${credentials.api_key}&q=${data.query}&maxResults=${data.maxResults}&startIndex=${data.startIndex}&printType=books&orderBy=relevance&langRestrict=en&country=UK`;
    const response = await got(url, { json: true });
    return response.body;
  } catch (error) {
    return error;
  };
});
