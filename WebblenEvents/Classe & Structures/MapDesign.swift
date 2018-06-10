//
//  MapDesign.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/10/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import Foundation

class CustomMap {
    
    class func getSimpleMapDesign() -> String {
        let simpleMap = "[" +
            "{" +
            "    \"stylers\": [" +
            "    {" +
            "        \"saturation\": -30" +
            "    }," +
            "    {" +
            "        \"weight\": 2.5" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"administrative\"," +
            "    \"elementType\": \"geometry\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"poi\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"poi.attraction\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"on\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"poi.business\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"on\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"poi.school\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"on\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"poi.sports_complex\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"on\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road\"," +
            "    \"elementType\": \"labels.icon\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road.arterial\"," +
            "    \"elementType\": \"labels\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road.highway\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"simplified\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road.highway\"," +
            "    \"elementType\": \"geometry\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"color\": \"#d5d5d5\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road.highway\"," +
            "    \"elementType\": \"labels\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"road.local\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}," +
            "{" +
            "    \"featureType\": \"transit\"," +
            "    \"stylers\": [" +
            "    {" +
            "        \"visibility\": \"off\"" +
            "    }" +
            "    ]" +
            "}" +
        "]"
        
        return simpleMap
    }
    
}
