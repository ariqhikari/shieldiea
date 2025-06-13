function isElementInViewport(el) {
  const rect = el.getBoundingClientRect();
  const windowHeight =
    window.innerHeight || document.documentElement.clientHeight;
  const windowWidth = window.innerWidth || document.documentElement.clientWidth;

  const elementHeight = rect.bottom - rect.top;
  const elementWidth = rect.right - rect.left;

  const visibleHeight = Math.max(
    0,
    Math.min(rect.bottom, windowHeight) - Math.max(rect.top, 0)
  );
  const visibleWidth = Math.max(
    0,
    Math.min(rect.right, windowWidth) - Math.max(rect.left, 0)
  );

  const isVisible =
    (visibleHeight * visibleWidth) / (elementHeight * elementWidth) >= 0.01;

  return isVisible;
}

function coverImages() {
  const divs = document.getElementsByTagName("div");
  const images = document.getElementsByTagName("img");

  const urlRegex = /(url\(['"]?)([^'")]+)(['"]?\))/; // Regular expression to match URLs in the format url('...') or url("...")

  for (let div of divs) {
    const backgroundImage = window.getComputedStyle(div).backgroundImage;

    const match = backgroundImage.match(urlRegex);
    if (match && match[2]) {
      const url = match[2]; // Extract the URL

      const img = new Image();
      img.src = url;

      img.onload = function () {
        const width = img.width;
        const height = img.height;
        if (width > 100 && height > 100) {
          if (isElementInViewport(div)) {
            div.style.filter = "blur(64px)";
          }
        }
      };

      img.onerror = function () {
        console.error("Gagal memuat gambar latar belakang:", url);
      };
    }
  }

  for (let img of images) {
    const imgWidth = img.width;
    const imgHeight = img.height;

    if (
      !img.dataset.covered &&
      imgWidth > 50 &&
      imgHeight > 50 &&
      !img.src.includes("logo") &&
      !img.src.includes("icon")
    ) {
      if (isElementInViewport(img)) {
        console.log(img);

        const overlay = document.createElement("div");
        overlay.style.position = "absolute";
        overlay.style.top = `${img.offsetTop}px`;
        overlay.style.left = `${img.offsetLeft}px`;
        overlay.style.width = `${imgWidth}px`;
        overlay.style.height = `${imgHeight}px`;
        overlay.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
        overlay.style.color = "white";
        overlay.style.display = "flex";
        overlay.style.flexDirection = "column";
        overlay.style.justifyContent = "center";
        overlay.style.alignItems = "center";
        overlay.style.fontSize = "16px";
        overlay.style.textAlign = "center";
        overlay.style.zIndex = "999999";

        img.style.filter = "blur(64px)";
        img.style.opacity = "0.7";

        const sensitiveText = document.createElement("div");
        sensitiveText.innerText = "Image Content";
        sensitiveText.style.fontSize = "18px";
        sensitiveText.style.fontWeight = "bold";
        overlay.appendChild(sensitiveText);

        const description = document.createElement("div");
        description.innerText =
          "This image may contain sensitive or disturbing content.";
        description.style.fontSize = "12px";
        overlay.appendChild(description);

        const loading = document.createElement("div");
        loading.innerText = "Loading...";
        loading.style.display = "block";
        overlay.appendChild(loading);

        // const button = document.createElement("button");
        // button.innerText = "See Image";
        // button.style.marginTop = "10px";
        // button.style.padding = "5px 15px";
        // button.style.backgroundColor = "transparent";
        // button.style.color = "white";
        // button.style.border = "1px solid white";
        // button.style.borderRadius = "5px";
        // button.style.cursor = "pointer";
        // button.onclick = function (e) {
        //   e.stopPropagation();
        //   e.preventDefault();

        //   loading.style.display = "block";
        //   button.disabled = true;
        // };

        // overlay.appendChild(button);

        img.parentNode.insertBefore(overlay, img);
        img.style.pointerEvents = "none";

        img.dataset.covered = "false";
        img.backgroundColor = "gray";

        fetch("https://Shieldiea.agrimate.software/predict-image", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            image_url: img.src,
          }),
        })
          .then((response) => response.json())
          .then((data) => {
            console.log("API response:", data);
            if (data.hasil === "porn") {
              img.src =
                "https://ariqhikari.github.io/proxy/assets/blocked-image.png";
            }

            overlay.remove();
            img.style.filter = "none";
            img.style.opacity = "1";
            img.dataset.covered = "true";
          })
          .catch((error) => {
            console.error("Error fetching API:", error);
          });
      }
    }
  }
}

// Fungsi lainnya tetap sama

function pauseAllVideos() {
  const videos = document.getElementsByTagName("video");

  for (let video of videos) {
    console.log("URL VIDEO:", video.currentSrc || video.src);
    // video.pause();
  }
}

let isCoverImagesRunning = false;
let isPauseVideosRunning = false;

function handleInteractionImage() {
  if (isCoverImagesRunning) return;

  isCoverImagesRunning = true;
  coverImages();
  isCoverImagesRunning = false;
}

function handleInteractionVideo() {
  if (isPauseVideosRunning) return;

  isPauseVideosRunning = true;
  pauseAllVideos();
  isPauseVideosRunning = false;
}

if (
  !window.location.href.includes("tiktok.com") &&
  !window.location.href.includes("youtube.com") &&
  !window.location.href.includes("Shieldiea-block.netlify.app")
) {
  const events = [
    "scroll",
    "click",
    "keydown",
    "mousemove",
    "touchstart",
    "touchmove",
    "touchend",
  ];

  events.forEach((event) => {
    window.addEventListener(event, () => {
      clearTimeout(window.interactionTimeout);
      window.interactionTimeout = setTimeout(handleInteractionImage, 100);
    });
  });

  handleInteractionImage();
}

// pauseAllVideos();

// const observer = new MutationObserver((mutations) => {
//   mutations.forEach((mutation) => {
//     if (mutation.type === "childList") {
//       console.log("New elements added to the DOM");
//       clearTimeout(window.interactionTimeout);
//       window.interactionTimeout = setTimeout(handleInteractionVideo, 100);
//     }
//   });
// });

// observer.observe(document.body, {
//   childList: true,
//   subtree: true,
// });

/// Block Video Youtube

function blockVideoYoutube() {
  const playerContainer = document.getElementById("player");
  const playerContainerOuter = document.getElementById(
    "player-container-outer"
  );

  if (playerContainer) {
    // const overlay = document.createElement("div");
    // overlay.style.position = "absolute";
    // overlay.style.top = 0;
    // overlay.style.width = "100%";
    // overlay.style.height = "100%";
    // overlay.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
    // overlay.style.color = "white";
    // overlay.style.display = "flex";
    // overlay.style.flexDirection = "column";
    // overlay.style.justifyContent = "center";
    // overlay.style.alignItems = "center";
    // overlay.style.fontSize = "16px";
    // overlay.style.textAlign = "center";
    // overlay.style.zIndex = "999999";

    // playerContainerOuter.style.filter = "blur(64px)";
    // playerContainerOuter.style.opacity = "0.7";

    // const sensitiveText = document.createElement("div");
    // sensitiveText.innerText = "Video Content";
    // sensitiveText.style.fontSize = "18px";
    // sensitiveText.style.fontWeight = "bold";
    // overlay.appendChild(sensitiveText);

    // const description = document.createElement("div");
    // description.innerText =
    //   "This video may contain sensitive or disturbing content.";
    // description.style.fontSize = "12px";
    // overlay.appendChild(description);

    // const loading = document.createElement("div");
    // loading.innerText = "Loading...";
    // loading.style.display = "block";
    // overlay.appendChild(loading);

    // playerContainer.appendChild(overlay);
    // playerContainer.style.pointerEvents = "none";

    // playerContainer.dataset.covered = "false";

    // setTimeout(() => {
    //   const img = document.createElement("img");
    //   img.backgroundColor = "gray";
    //   img.src = "https://ariqhikari.github.io/proxy/assets/blocked-video.png";

    //   overlay.remove();
    //   img.style.position = "absolute";
    //   img.style.top = 0;
    //   img.style.width = "100%";
    //   img.style.height = "100%";
    //   img.style.objectFit = "cover";
    //   img.style.pointerEvents = "none";
    //   playerContainer.appendChild(img);
    // }, 500);

    const img = document.createElement("img");
    img.backgroundColor = "gray";
    img.src = "https://ariqhikari.github.io/proxy/assets/blocked-video.png";
    img.style.position = "absolute";
    img.style.top = 0;
    img.style.width = "100%";
    img.style.height = "100%";
    img.style.objectFit = "cover";
    img.style.pointerEvents = "none";
    playerContainer.appendChild(img);
  }
}

const urlYoutube = ["MALTaCF0b2g", "M1YI40N2e3A", "I4nI_rowdhM", "we6PRXmfils"];

const url = window.location.href;

if (
  url.includes("MALTaCF0b2g") ||
  url.includes("BbO_NbrYl1s") ||
  url.includes("BSfcoKY1tiM") ||
  url.includes("6gJCIvU_3ao") ||
  url.includes("S5ayio-n6BM")
) {
  console.log("MASUK PA EKO");
  blockVideoYoutube();
}

// * Character
const style = document.createElement("style");
style.textContent = `
  @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap");

  .chatbot * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
  }
  .chatbot-toggler img, .chatbot img {
    width: 100%;
  }
  .chatbot-toggler {
    position: fixed;
    bottom: 10px;
    right: 10px;
    outline: none;
    border: none;
    height: 100px;
    width: 100px;
    display: flex;
    cursor: pointer;
    align-items: center;
    justify-content: center;
    background: transparent;
    transition: opacity 0.3s ease;
  }
  body.show-chatbot .chatbot-toggler {
    opacity: 0;
  }
  .chatbot-toggler span {
    color: #fff;
    position: absolute;
  }
  .chatbot-toggler span:last-child,
  body.show-chatbot .chatbot-toggler span:first-child {
    opacity: 0;
  }
  body.show-chatbot .chatbot-toggler span:last-child {
    opacity: 1;
  }
  .chatbot {
    position: fixed;
    z-index: 99999;
    right: 35px;
    bottom: 90px;
    width: 420px;
    background: #fff;
    border-radius: 15px;
    overflow: hidden;
    opacity: 0;
    pointer-events: none;
    transform: scale(0.5);
    transform-origin: bottom right;
    box-shadow: 0 0 5px 0 rgba(0, 0, 0, 0.25);
    transition: all 0.1s ease;
  }
  body.show-chatbot .chatbot {
    opacity: 1;
    pointer-events: auto;
    transform: scale(1);
  }
  .chatbot header {
    padding: 16px 0;
    position: relative;
    text-align: center;
    color: #fff;
    background: #4C753F;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }
  .chatbot header span {
    position: absolute;
    right: 15px;
    top: 50%;
    display: none;
    cursor: pointer;
    transform: translateY(-50%);
  }
  header h2 {
    font-size: 1.4rem;
  }
  .chatbox {
    overflow-y: auto;
    height: 510px;
    padding: 30px 20px 100px;
  }
  .chatbox .chat {
    display: flex;
    list-style: none;
  }
  .chatbox .outgoing {
    margin: 20px 0;
    justify-content: flex-end;
  }
  .chatbox .chat p {
    white-space: pre-wrap;
    padding: 12px 16px;
    border-radius: 10px 10px 0 10px;
    max-width: 75%;
    color: #fff;
    font-size: 0.95rem;
    background: #4C753F;
    opacity: 0;
    animation: revealText 1s forwards;
  }
  .chatbox .incoming p {
    margin-left: 10px;
    border-radius: 10px 10px 10px 0;
    color: #000;
    background: #f2f2f2;
  }

  @keyframes revealText {
    0% {
      opacity: 0;
      transform: translateY(20px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .chat-input {
    display: flex;
    gap: 5px;
    position: absolute;
    bottom: 0;
    width: 100%;
    background: #fff;
    padding: 3px 20px;
    border-top: 1px solid #ddd;
  }
  .chat-input textarea {
    height: 55px;
    width: 100%;
    border: none;
    outline: none;
    resize: none;
    max-height: 180px;
    padding: 15px 15px 15px 0;
    font-size: 0.95rem;
  }
  .chat-input span {
    align-self: flex-end;
    color: #4C753F;
    cursor: pointer;
    height: 55px;
    display: flex;
    align-items: center;
    visibility: hidden;
    font-size: 1.35rem;
  }
  .chat-input textarea:valid ~ span {
    visibility: visible;
  }

  @media (max-width: 768px) {
    .chatbot {
      width: 90%;
      bottom: 70px;
      right: 5%;
      max-width: 400px;
    }

    .chatbot .chatbox {
      height: 380px;
      padding: 20px 15px 80px;
    }

    .chat-input textarea {
      font-size: 0.9rem;
      padding: 12px 15px;
    }

    .chat-input span {
      font-size: 1.2rem;
    }

    .chatbot header {
      padding: 12px 0;
    }

    header h2 {
      font-size: 1.2rem;
    }
  }
`;
document.head.appendChild(style);

const chatbotToggler = document.createElement("button");
chatbotToggler.className = "chatbot-toggler";
chatbotToggler.innerHTML = `
  <span>
    <img src="https://ariqhikari.github.io/proxy/assets/ic_chatbot.svg" />  
  </span>
  <span>
      <img src="https://ariqhikari.github.io/proxy/assets/ic_close.svg" />  
  </span>
`;
document.body.appendChild(chatbotToggler);

const chatbot = document.createElement("div");
chatbot.className = "chatbot";
chatbot.innerHTML = `
  <header>
    <h2>Shieldiea Chatbot</h2>
  </header>
  <ul class="chatbox">
    <li class="chat incoming">
      <span>
        <img src="https://ariqhikari.github.io/proxy/assets/ic_bot.svg" />  
      </span>
      <p>Hi there 👋<br />How can I help you today?</p>
    </li>
  </ul>
  <div class="chat-input">
    <textarea placeholder="Enter a message..." spellcheck="false" required></textarea>
    <span id="send-btn">
      <img src="https://ariqhikari.github.io/proxy/assets/ic_send.svg" />  
    </span>
  </div>
`;
document.body.appendChild(chatbot);

const closeBtn = chatbot.querySelector(".close-btn");
const chatbox = chatbot.querySelector(".chatbox");
const chatInput = chatbot.querySelector("textarea");
const sendChatBtn = chatbot.querySelector("#send-btn");

let userMessage = null;

const createChatLi = (message, className) => {
  const chatLi = document.createElement("li");
  chatLi.classList.add("chat", className);
  chatLi.innerHTML =
    className === "outgoing"
      ? `<p>${message}</p>`
      : `<span><img src="https://ariqhikari.github.io/proxy/assets/ic_bot.svg" />  </span><p>${message}</p>`;
  return chatLi;
};

const typeMessage = (message, chatElement) => {
  const words = message.split(" ");
  let i = 0;

  const intervalId = setInterval(() => {
    chatElement.querySelector("p").textContent += words[i] + " ";
    i++;

    if (i >= words.length) {
      clearInterval(intervalId);
    }
  }, 100);
};

const generateResponse = (chatElement) => {
  setTimeout(() => {
    chatElement.querySelector("p").textContent = "";
    const responseMessage =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.";
    typeMessage(responseMessage, chatElement);
    chatbox.scrollTo(0, chatbox.scrollHeight);
  }, 600);
};

const handleChat = () => {
  userMessage = chatInput.value.trim();
  if (!userMessage) return;

  chatInput.value = "";

  chatbox.appendChild(createChatLi(userMessage, "outgoing"));
  chatbox.scrollTo(0, chatbox.scrollHeight);

  setTimeout(() => {
    const incomingChatLi = createChatLi("Thinking...", "incoming");
    chatbox.appendChild(incomingChatLi);
    chatbox.scrollTo(0, chatbox.scrollHeight);
    generateResponse(incomingChatLi);
  }, 600);
};

sendChatBtn.addEventListener("click", handleChat);
chatInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    handleChat();
  }
});

chatbotToggler.addEventListener("click", () => {
  const isChatbotOpen = document.body.classList.toggle("show-chatbot");
  if (isChatbotOpen) {
    chatbotToggler.style.opacity = 0;
    setTimeout(() => (chatbotToggler.style.opacity = 1), 300);
  } else {
    chatbotToggler.style.opacity = 0;
    setTimeout(() => (chatbotToggler.style.opacity = 1), 300);
  }
});

closeBtn.addEventListener("click", () =>
  document.body.classList.remove("show-chatbot")
);
