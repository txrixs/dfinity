import Int "mo:base/Int";
import Text "mo:base/Text";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";


actor{

    public type Time = Time.Time;
    public type Message = {
        text: Text;
        time: Time;
    };
    public type Microblog = actor{
        follow: shared (Principal) -> async ();
        follows: shared query() -> async [Principal];
        post: shared (Time) -> async ();
        posts: shared query (Time) -> async [Message];
        timeline: shared (Time) -> async [Message];
    };

    stable var followed : List.List<Principal> = List.nil();
    stable var messages : List.List<Message> = List.nil();

    public shared func follow(id: Principal) : async (){
        followed := List.push(id, followed);
    };
    
    public shared query func follows() : async [Principal]{
        List.toArray(followed)
    };

    public shared ({caller}) func post(text: Text) : async (){
  
        var msg : Message = {
            text = text;
            time = Time.now();
        };
        messages := List.push(msg, messages);
    };

    public shared query func posts(since: Time) : async [Message]{
        var all : List.List<Message> = List.nil();
        for(msg in Iter.fromArray(List.toArray(messages))){
            if(msg.time >= since){
                all := List.push(msg, messages);
            };
        };
        List.toArray(all)
    };

    public shared func timeline(since: Time) : async [Message]{
        var all : List.List<Message> = List.nil();
        for(id in Iter.fromList(followed)){
            let canister : Microblog = actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for(msg in Iter.fromArray(msgs)){
                all := List.push(msg, all);
            };
        };
        List.toArray(all)
    };

};
