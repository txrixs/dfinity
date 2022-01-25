import { helloworld } from "../../declarations/helloworld";

async function setName(){
	document.getElementById("err_setname").innerText = "";
	let setname = document.getElementById("setname");
	let text = setname.value;
	try{
		await helloworld.setName(text);
		setname.value= "";
	}catch(err){
		console.log(err);
		document.getElementById("err_setname").innerText = "保存失败";
	}
} 

async function post(){
	let post_button = document.getElementById("post");
	document.getElementById("err").innerText = "";
	post_button.disabled = true;
	let textarea = document.getElementById("message");
	let text = textarea.value;
	try{
		await helloworld.post(text);
		textarea.value= "";
	}catch(err){
		console.log(err);
		document.getElementById("err").innerText = "提交失败";
	}
	
	post_button.disabled = false;
} 

var num_posts = 0;
async function load_posts(){
	let post_section= document.getElementById("posts");
	post_section.replaceChildren([]);
	let posts = await helloworld.posts();
	console.log(posts);
	if(num_posts == posts.length) return;
	post_section.replaceChildren([]);
	for(i=0 ;i<posts.length;i++){
		let post= document.createElement("p");
		post.innerText = posts[i].content;
		post_section.appendChild(post);
	}
}

var num_timeline = 0;
async function load_timeline(){
	let post_section= document.getElementById("timeline");
	post_section.replaceChildren([]);
	let posts = await helloworld.timeline();
	console.log(posts);
	if(num_timeline == posts.length) return;
	post_section.replaceChildren([]);
	for(i=0 ;i<posts.length;i++){
		let post= document.createElement("p");
		post.innerText = posts[i].content+"    作者：" + post[i].author + "    时间：" + getYMDHMS(post[i].createTime);
		post_section.appendChild(post);
	}
}

var num_follows = 0;
async function load_follows(){
	let follows= document.getElementById("follows");
	follows.replaceChildren([]);
	let posts = await helloworld.follows();
	console.log(posts);
	if(num_follows == posts.length) return;
	follows.replaceChildren([]);
	for(i=0 ;i<posts.length;i++){
		let post= document.createElement("p");
		post.innerText = posts[i];
		follows.appendChild(post);
	}
}

function getYMDHMS (timestamp) {
      let time = new Date(timestamp)
      let year = time.getFullYear()
      const month = (time.getMonth() + 1).toString().padStart(2, '0')
      const date = (time.getDate()).toString().padStart(2, '0')
      const hours = (time.getHours()).toString().padStart(2, '0')
      const minute = (time.getMinutes()).toString().padStart(2, '0')
      const second = (time.getSeconds()).toString().padStart(2, '0')

      return year + '-' + month + '-' + date + ' ' + hours + ':' + minute + ':' + second
}

window.onload=function(){
	let post_button = document.getElementById("post");
	post_button.onclick = post;
	let btn_setname = document.getElementById("btn_setname");
	btn_setname.onclick = setName;
	load_posts();
	load_timeline();
	load_follows();
	//setInterval(load_posts,1000);
	//setInterval(load_timeline,1000);
	//setInterval(load_follows,1000);
};

