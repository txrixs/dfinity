import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Text "mo:base/Text";


actor Counter_re {

    stable var currentValue : Nat = 0;

    public query func get() : async Nat {
    return currentValue;
    };

    public func set(n : Nat) : async () {
    currentValue := n;
    };

    public func inc() : async () {
    currentValue += 1;
    };
    
    
    public type ChunkId = Nat;
    public type HeaderField = (Text, Text);

    public type StreamingStrategy = {
        #Callback : {
        token : StreamingCallbackToken;
        callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };

    public type Key = Text;
    public type Path = Text;

    public type SetAssetContentArguments = {
        key : Key;
        sha256 : ?[Nat8];
        chunk_ids : [ChunkId];
        content_encoding : Text;
    };

    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };

    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };

    type HttpRequest = {
        method: Text;
        url: Text;
        headers: [HeaderField];
        body: [Nat8];
    };

    type HttpResponse = {
        status_code: Nat16;
        headers: [HeaderField];
        Streaming_Strategy: ?StreamingStrategy;
        body: Blob;
    };

    public query func http_request(request : HttpRequest) : async HttpResponse {

        Debug.print("Woah, it works!!");
        return {
            status_code = 200;
            Streaming_Strategy = null;
            headers = [("Content-Type", "text/html")];
            body = Text.encodeUtf8("<html><body><h1>"#debug_show(currentValue)#"</h1></body></html>");
        };
    };

}
