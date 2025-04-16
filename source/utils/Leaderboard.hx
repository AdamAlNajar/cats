package utils;

import haxe.Http;

class Leaderboard {
    static var BASE_URL = "https://cats-leaderboard-system-default-rtdb.asia-southeast1.firebasedatabase.app/scores.json"; 

    // Function to submit a score
    public static function submitScore(playerName:String, score:Int) {
        var http = new Http(BASE_URL);
        var data = haxe.Json.stringify({name: playerName, score: score});
        
        http.setHeader("Content-Type", "application/json");
        http.setPostData(data);

        http.onData = function(response:String) {
            trace("Score submitted successfully: " + response);
        };

        http.onError = function(error:String) {
            trace("Failed to submit score: " + error);
        };

        http.request(true);
    }

    // Function to retrieve scores
    public static function getScores(callback:Array<{name:String, score:Int}>->Void) {
        var http = new Http(BASE_URL);

        http.onData = function(response:String) {
            var scores:Map<String, {name:String, score:Int}> = haxe.Json.parse(response);
            var scoreList:Array<{name:String, score:Int}> = [];

            for (key in scores.keys()) {
                scoreList.push(scores[key]);
            }

            scoreList.sort((a, b) -> b.score - a.score); // Sort from highest to lowest
            callback(scoreList);
        };

        http.onError = function(error:String) {
            trace("Failed to fetch leaderboard: " + error);
        };

        http.request();
    }
}
