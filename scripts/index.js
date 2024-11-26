import * as THREE from "three";
    
const img_base = "assets/HeroPanorama..png";

let camera, scene, renderer, skybox;
let height = 0;
const heroSection = document.querySelector(".Hero");

init();
animate();

function init() {
const container = document.getElementById("container");

scene = new THREE.Scene();
scene.background = new THREE.Color(0x101010);

const light = new THREE.AmbientLight(0xffffff, 3.3);
scene.add(light);

camera = new THREE.PerspectiveCamera(
    70,
    window.innerWidth / window.innerHeight,
    1,
    50
);
scene.add(camera);

const panoSphereGeo = new THREE.SphereGeometry(30, 500, 500);
const panoSphereMat = new THREE.MeshStandardMaterial({
    side: THREE.BackSide,
    displacementScale: -28.0
});
skybox = new THREE.Mesh(panoSphereGeo, panoSphereMat);

const manager = new THREE.LoadingManager();
const loader = new THREE.TextureLoader(manager);

loader.load(img_base, function (texture) {
    texture.colorSpace = THREE.SRGBColorSpace;
    texture.minFilter = THREE.NearestFilter;
    texture.generateMipmaps = false;
    skybox.material.map = texture;
});



manager.onLoad = function () {
    scene.add(skybox);
};

renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setPixelRatio(window.devicePixelRatio);
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.useLegacyLights = false;

container.appendChild(renderer.domElement);

height = heroSection.offsetHeight;

window.addEventListener("scroll", scrollAction);
window.addEventListener("resize", onWindowResize);
}

function scrollAction() {
const heroRect = heroSection.getBoundingClientRect();
if (heroRect.bottom >= 0 && heroRect.top <= window.innerHeight) {
    const scrollAmount = (window.innerHeight - heroRect.bottom) / height;
    const angle = Math.min(Math.max(scrollAmount * Math.PI * 2, 0), Math.PI * 2);

    skybox.rotation.y = angle;
    skybox.position.y = Math.sin(angle * 2);
    skybox.position.x = Math.sin(angle * 2) * 2;
}
}

function onWindowResize() {
height = heroSection.offsetHeight;

camera.aspect = window.innerWidth / window.innerHeight;
camera.updateProjectionMatrix();
renderer.setSize(window.innerWidth, window.innerHeight);
}

function animate() {
requestAnimationFrame(animate);
renderer.render(scene, camera);
}
