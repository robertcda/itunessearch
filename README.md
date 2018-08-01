# iTunes Search

A simple application to search through some media content in iTunes.
Works on iPhone and iPad.

## Proud of

Network Layer, Model Interpretation, View Model
- Separated the Network APi and model interpretation, which allowed me to simulate API mocking.
- Basically Network Layer doesnt know business and ModelInterpretator bridges that to the application.

Used MockAPI to test.
- Since i was not allowed to use any 3rd party app, i thought that the best way to mock APis would be to introduce dependency injection at the construction of the ModelInterpretor, which allowed me to mock the APIs.

Using Screen real estate better on iPhone and iPad using traits.
- A basic thing but made the UI to be a bit different in iPhone and iPad.

ImageState to maintain the state of the ImageView in the masterCell and detailCell.
- To maintain if the image is availabe for a cell, I introduced states, which help in better code readability.
- yes, I enjoy writing enums in swift :)

Tried to write and rewrite quite a bit of the code to ensure that less code does more.

## Improvements

- Many more test cases for the view models could have been written. But given the time my focus was on getting the functionlity up and running.
- I did a sample of each type of test case, but In reality need to check both positive and negative scenarios.
- If I had the luxury of time, i would first start writing the test cases and write the protocol and then implement the protocol in the model.
- followed a simple logic to ensure that the latest search results will be shown by maintaining an instance variable of the latest searched text. Given more time, i think i would stop the previous tasks and execute the latest one, instead of currently just disregarding the response.
- Wanted to resolve the constraint errors when no track is selected.
- Couldn’t do much code commenting for maintainability, but added stuff here and there during my work where i felt like.
- Didn’t even attemp to do backward compatibility.

## Disclaimer
I have a release tomorrow(2-Aug) in my project so will not be able to spend much time tomorrow, so hopefully this is sufficient for now.



