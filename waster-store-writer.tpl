___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Waster Store Writer",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Use this tag for writing data to the Waster Store.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "CHECKBOX",
    "name": "addEventData",
    "checkboxText": "Add Event Data",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "documentId",
    "displayName": "Document ID (optional)",
    "simpleValueType": true,
    "help": "Leave empty to auto-generate"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "fieldsToSave",
    "displayName": "Fields to Save",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Field Name",
        "name": "fieldName",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "fieldValue",
        "type": "TEXT"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const fetch = require('sendHttpRequest');
const JSON = require('JSON');
const getAllEventData = require('getAllEventData');
const logToConsole = require('logToConsole');
const getTimestampMillis = require('getTimestampMillis');
const getEventData = require('getEventData');
const getRequestHeader = require('getRequestHeader');

const collection = data.collection;
const documentId = data.documentId || 'auto-generated-' + getTimestampMillis();

const fields = data.addEventData ? getAllEventData() : {};

if (data.fieldsToSave && data.fieldsToSave.length > 0) {
  data.fieldsToSave.forEach(function(field) {
    if (field.fieldName && field.fieldValue !== undefined) {
      let processedValue = field.fieldValue;
      
      fields[field.fieldName] = processedValue;
    }
  });
}

const currentTimestampMillis = getTimestampMillis();
fields.timestamp = currentTimestampMillis;
fields.event_name = data.event_name_standard;

const url = getHost();

fields.documentId = documentId;

const payload = {
  document_key: documentId,
  data: fields
};

const response = fetch(url, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-container-identifier': getRequestHeader('x-container-identifier') || 'default-idt',
    'x-user-id': getRequestHeader('x-user-id') || 'default-container'
  }
}, JSON.stringify(payload));

response.then((res) => {  
  if (res.statusCode >= 200 && res.statusCode < 300) {
    logToConsole('Dados salvos com sucesso no Waster Store');
    data.gtmOnSuccess();
  } else {
    logToConsole('Erro ao salvar no Waster Store:', res.body);
    data.gtmOnFailure();
  }
}).catch((error) => {
  logToConsole('Erro na requisição:', error);
  data.gtmOnFailure();
});

function getHost() {
  const host = getRequestHeader('x-url-api') || '';

  return (
    host +
    '/save'
  );
}


___SERVER_PERMISSIONS___

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
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
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
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
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
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-container-identifier"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-user-id"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gtm-server-preview"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-url-api"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
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

scenarios: []


___NOTES___

Created on 02/06/2025, 21:46:45


