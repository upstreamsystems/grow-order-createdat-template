___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Grow - Order CreatedAt",
  "categories": ["ATTRIBUTION", "MARKETING", "PERSONALIZATION", "REMARKETING", "CONVERSIONS"],
  "description": "Captures the order timestamp from the data layer",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "createdAt",
    "displayName": "CreatedAt - Optional",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const log = require('logToConsole');
const queryPermission = require('queryPermission');
const copyFromDataLayer = require('copyFromDataLayer');
const getType = require('getType');

const rawKey = data.createdAt;
if (rawKey === undefined) return undefined;

const dlKey = rawKey.trim();
if (dlKey === '') return undefined;

if (!queryPermission('read_data_layer', dlKey)) {
  log('you dont have permission to read', dlKey);
  return undefined;
}

const value = copyFromDataLayer(dlKey);
const regex = '((19|20)[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T(0[0-1]|1[0-9]|2[0-3]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9])' + '\\'+'.' + '[0-9]{3}Z';

const isValidISOTimestamp = getType(value) === 'string' && value.match(regex);

if (isValidISOTimestamp) {
  return value;
}

return undefined;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Returns createdAt from DL (timestamp)
  code: |-
    const mockData = {
      createdAt: 'date'
    };

    mock('copyFromDataLayer', function (key) {
      const map = {
        id: 5,
        date: '2024-03-28T11:53:26.046Z'
      };
      return map[key];
    });

    const res = runCode(mockData);
    assertThat(res).isEqualTo('2024-03-28T11:53:26.046Z');
- name: Returns undefined if createdAt is not set
  code: |-
    const mockData = {
    };

    mock('copyFromDataLayer', function (key) {
      const map = {
        id: 5,
        date: '2024-03-28T11:53:26.046Z'
      };
      return map[key];
    });

    const res = runCode(mockData);
    assertThat(res).isEqualTo(undefined);
- name: Returns undefined if createdAt is empty
  code: |-
    const mockData = {
       customerID: ''
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo(undefined);
- name: Returns undefined if createdAt is a string but not an ISO timestamp
  code: |-
    const mockData = {
      createdAt: 'date'
    };

    mock('copyFromDataLayer', function (key) {
      const map = {
        id: 5,
        date: '2024-03-28T26.046'
      };
      return map[key];
    });

    const res = runCode(mockData);
    assertThat(res).isEqualTo(undefined);


___NOTES___

Created on 12/04/2024, 17:10:53


