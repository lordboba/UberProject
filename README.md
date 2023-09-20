# RideHop
![Logo](https://github.com/lordboba/UberProject/assets/56620132/93cb6d98-7b4b-487b-87f7-27b481e7515e)


## About
Ride sharing services and public transit aren't integrated very well as of now. A diverse set of individuals are bound to prioritize different aspects when considering their transportation mode. There are those who prefer ridesharing like Uber and Lyft for their on-demand availability & accessible service from any location while there are also those who prefer buses, subways, and other public transit options for their inexpensive cost and ability to reduce greenhouse gas emissions per passenger. Users of public transit also don't opt to use ridesharing for traveling to and from public transit stations. To solve this issue, our app makes using both public transit and ridesharing more convenient through planning routes that uses both ridesharing and public transit on one platform. 


## Implementation
RideHop is an iOS app written in Swift. It uses Google Places API to generate map locations from addresses. Then the user's location obtained from GPS and their chosen destination is passed along to the Google Routes API to generate potential routes. All the transit modes, no route modifiers (avoid tolls, highways, or ferries), and compute alternative routes were chosen to give the users a wide variety of options. The API to return detailed information for every step of each route, including the estimated time, distance, type of travel, start and end locations, and public transit departure time and arrival time. Then emissions for each route is calculated individually based on average grams of CO2 per passenger mile for each mode of transportion multiplied with the distance travelled in miles. 


## How to use
The app opens to a search bar and a map. To choose a destination, search for it in the search bar. The location then pops up on the map for confirmation of correct destination. Many different options of routes with differing modes of transportation are shown. The first route is only ridesharing while the others use public transit. Each route have emissions, time, and price data displayed for more informed decision. A drop down menu at the top allows for routes to be sort by emissions, time, or price.

![Map and Search](https://github.com/lordboba/UberProject/assets/56620132/77acbe10-569b-4375-8c15-62c526ce2337)

![Search for Destination](https://github.com/lordboba/UberProject/assets/56620132/f68f43d6-e489-4b24-b2cb-69066000e3cd)

![Destination on Map](https://github.com/lordboba/UberProject/assets/56620132/0def199e-6442-4974-9e71-285a3ef246a6)

![Routes and Sorting](https://github.com/lordboba/UberProject/assets/56620132/1b3ca4b6-0157-44ac-853f-3bddbb019b64)
