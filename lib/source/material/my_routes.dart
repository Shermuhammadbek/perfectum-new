

import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';
import 'package:perfectum_new/presentation/enterance/login/password_screen.dart';
import 'package:perfectum_new/presentation/enterance/login/splash_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home.dart';

Map<String, Widget Function(BuildContext)> myRoutes = {
  //? InitialPage
  
  Home.routeName: (ctx) {return const Home();},

  PasswordScreen.routeName: (ctx) 
    {return const PasswordScreen();},

  LoginScreen.routeName: (ctx)
    {return const LoginScreen();},

  SplashScreen.routeName: (ctx)
    {return const SplashScreen();},

};



/*
{
    "data": [
        {
            "id": "PO_Test_Offer3",
            "name": "Test offer 3",
            "allowances": [],
            "categories": [
                "prepaid",
                "commercial",
                "plan"
            ]
        },
        {
            "id": "PO_Test_Offer2",
            "name": "Test offer 2",
            "allowances": [
                {
                    "type": "national-data",
                    "id": "A_Data_400_GB",
                    "allowance": 400,
                    "unit-of-measure": "gigabytes"
                }
            ],
            "categories": [
                "prepaid",
                "commercial",
                "plan"
            ]
        },
        {
            "id": "PO_Test_Addon3",
            "name": "Test addon 3",
            "allowances": [
                {
                    "type": "national-data",
                    "id": "A_Data_100_GB",
                    "allowance": 100,
                    "unit-of-measure": "gigabytes"
                }
            ],
            "categories": [
                "additional",
                "commercial",
                "non-recurring",
                "mobile"
            ]
        },
        {
            "id": "PO_Test_Addon1",
            "name": "Test addon 1",
            "allowances": [
                {
                    "type": "national-data",
                    "id": "A_Data_50_GB",
                    "allowance": 50,
                    "unit-of-measure": "gigabytes"
                }
            ],
            "categories": [
                "additional",
                "commercial",
                "non-recurring",
                "mobile"
            ]
        },
        {
            "id": "PO_Test_Offer1",
            "name": "Test offer 1",
            "allowances": [
                {
                    "type": "sms",
                    "id": "A_SMS_2500",
                    "allowance": 2500,
                    "unit-of-measure": "pieces"
                },
                {
                    "type": "national-data",
                    "id": "A_Data_200_GB",
                    "allowance": 200,
                    "unit-of-measure": "gigabytes"
                },
                {
                    "type": "social-media-data",
                    "id": "A_Social_Media_UNL",
                    "allowance": -1,
                    "unit-of-measure": "gigabytes"
                },
                {
                    "type": "national-voice",
                    "id": "A_Voice_UNL",
                    "allowance": -1,
                    "unit-of-measure": "minutes"
                }
            ],
            "categories": [
                "prepaid",
                "commercial",
                "plan"
            ]
        },
        {
            "id": "PO_Test_Addon2",
            "name": "Test addon 2",
            "allowances": [
                {
                    "type": "national-data",
                    "id": "A_Data_100_GB",
                    "allowance": 100,
                    "unit-of-measure": "gigabytes"
                }
            ],
            "categories": [
                "additional",
                "commercial",
                "non-recurring",
                "mobile"
            ]
        },
        {
            "id": "PO_Test_Offer_3_included_allowances",
            "name": "PO_Test_Offer_3_included_allowances",
            "allowances": [
                {
                    "type": "sms",
                    "id": "A_SMS_3000",
                    "allowance": 3000,
                    "unit-of-measure": "pieces"
                },
                {
                    "type": "social-media-data",
                    "id": "A_Social_Media_UNL",
                    "allowance": -1,
                    "unit-of-measure": "gigabytes"
                },
                {
                    "type": "national-data",
                    "id": "A_Data_400_GB",
                    "allowance": 400,
                    "unit-of-measure": "gigabytes"
                },
                {
                    "type": "national-voice",
                    "id": "A_Voice_UNL",
                    "allowance": -1,
                    "unit-of-measure": "minutes"
                }
            ],
            "categories": [
                "prepaid",
                "commercial",
                "additional"
            ]
        }
    ]
}
 */