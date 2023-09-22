# StepsCounter

## Today Tab
The app makes use of the HealthKit framework to fetch the step count and displays it in the Today tab. The data automatically refreshes every 5 minutes and is stored in a local DB(using CoreData) and synced with the backend using network API(https://testapi.mindware.us/steps). The progress bar shows the percentage of the total goal completed and a bar chart at the bottom shows the steps for every hour of the day.


## History Tab: 

This tab shows the **7 Days** and **30 Days** history of step count. When toggling between the history types the BarChart will be updated accordingly.
