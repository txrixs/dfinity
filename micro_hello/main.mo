import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Debug "mo:base/Debug";

actor {
    public type Message = { 
	content:Text;
	createTime:Int;
	author:Text;
    };
    public type Microblog = actor {
        follow : shared (Principal) -> async ();
        follows : shared query () -> async [Principal];
   	post : shared (Text) -> async ();
 	posts : shared query (Time.Time) -> async [Message];
	timeline : shared (Time.Time) -> async [Message];
	getName : shared query () -> async Text;
	setName : shared (Text) -> async ();
    };

    var myName = "";

    public shared query func getName(): async Text{
	myName;
    };

    public shared func setName(name: Text) : async (){
	myName := name;	
    };
    
    var followed:List.List<Principal> = List.nil();
    
    public shared func follow(id: Principal) : async (){ 
	followed := List.push(id,followed); 
    };
    
    public shared query func follows() : async [Principal]{ 
	List.toArray(followed); 
    };
    
    var messages:List.List<Message> = List.nil();
    
    public shared func post(text:Text) : async () { 
	let msg: Message = { 
	    content = text;
	    createTime = Time.now(); 
	    author = myName;
	};
	messages := List.push(msg,messages);
    };
    
    public shared query func posts(since: Time.Time) : async [Message] { 
	var posts:List.List<Message> = List.nil();
	for(msg in Iter.fromList(messages)){
	    if(msg.createTime > since){ posts := List.push(msg,posts); }
	};
	List.toArray(posts); 
    };

    public shared func timeline(since: Time.Time) : async [Message] {
	var all:List.List<Message> = List.nil();
	for(id in Iter.fromList(followed)){
	    let canister : Microblog = actor(Principal.toText(id));
	    let msgs = await canister.posts(since);
	    for(msg in Iter.fromArray(msgs)){ all := List.push(msg,all) };
	};
     	List.toArray(all);
    };
};
