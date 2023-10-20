
document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");
  const name = document.getElementById("name").value.toString();
  const a = parseInt(document.getElementById("a").value);
  const b = parseInt(document.getElementById("b").value);

  button.setAttribute("disabled", true);

  // Interact with foo actor, calling the greet method
  const greeting = await Invernados_backend.greet(name);
  const result = await Invernados_backend.add(a, b);

  button.removeAttribute("disabled");
  document.getElementById("greeting").innerText = greeting;
  document.getElementById("number").innerText = result.toString();

  return false;
});