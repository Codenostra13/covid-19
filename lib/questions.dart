import 'package:flutter/material.dart';

const QUESTIONS = [
    {
      "id": 1,
      "question": "Do you have fever?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 2,
      "question": "What fever do you have ?",
      "conditions": [
        {"question": 1, "option": 1}
      ],
      "options": [
        {
          "title": " > 38 (100 F)",
          "point": 1.0,
          "value": 1,
          "color": Colors.red
        },
        {
          "title": " < 38 (100 F)",
          "point": 0.0,
          "value": 0,
          "color": Colors.green
        }
      ]
    },
    {
      "id": 3,
      "question": "Do you have cough?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 4,
      "question": "Do you have fatigue?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 5,
      "question": "Do you have shortness of breath?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 6,
      "question": "Do you have headache?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 7,
      "question": "Do you have body aches and pains?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 8,
      "question": "How old are you?",
      "conditions": [],
      "options": [
        {
          "title": "Younger than 25",
          "point": 0.0,
          "value": 0,
          "color": Colors.green
        },
        {
          "title": "25-40",
          "point": 0.5,
          "value": 1,
          "color": Colors.yellowAccent
        },
        {"title": "40-60", "point": 1.0, "value": 2, "color": Colors.orange},
        {"title": "60 and more", "point": 2.0, "value": 3, "color": Colors.red},
      ]
    },
    {
      "id": 9,
      "question":
          "Do you have underlying health conditions, such as diabetes, high blood pressure and chronic heart or lung  conditions?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 10,
      "question":
          "Did you travel in an area where COVID-19 illness is widespread or community transmission is occuring?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    },
    {
      "id": 11,
      "question":
          "Where you in close contact with someone who has a confirmed infection?",
      "conditions": [],
      "options": [
        {"title": "Yes", "point": 1.0, "value": 1, "color": Colors.red},
        {"title": "No", "point": 0.0, "value": 0, "color": Colors.green}
      ]
    }
];