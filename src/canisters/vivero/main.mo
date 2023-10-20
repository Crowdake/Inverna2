import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
actor Vivero {
  type ViveroId = Nat32;
  public type Vivero = {
    orticultor: Principal;
    fechaCreacion: Text;
    temporadaActual: Text;
  };

  stable var viveroId: ViveroId = 0;
  let viveroList = HashMap.HashMap<Text, Vivero>(0, Text.equal, Text.hash);

  private func generatePostId() : Nat32 {
    viveroId += 1;
    return viveroId;
  };

  public shared (msg) func crearPost(fechaCreacion: Text, temporadaActual: Text) : async () {
    let orticultor: Principal = msg.caller;
    let vivero = {orticultor = orticultor; fechaCreacion = fechaCreacion; temporadaActual = temporadaActual};
    viveroList.put(Nat32.toText(generatePostId()), vivero);
    Debug.print("¡Nuevo vivero creado! ID: " # Nat32.toText(viveroId));
    return ();
  };

  public query func obtenerPosts() : async [(Text, Vivero)] {
    let viveroIter : Iter.Iter<(Text, Vivero)> = viveroList.entries();
    let viveroArray : [(Text, Vivero)] = Iter.toArray(viveroIter);
    return viveroArray;
  };

  public query func obtenerPost(id: Text) : async ?Vivero {
    let vivero: ?Vivero = viveroList.get(id);
    return vivero;
  };

  public shared (msg) func actualizarPost(id: Text, fechaCreacion: Text, temporadaActual: Text) : async Bool {
    let orticultor: Principal = msg.caller;
    let vivero: ?Vivero = viveroList.get(id);
    switch (vivero) {
      case (null) {
        return false;
      };
      case (?currentPost) {
        let newPost: Vivero = {orticultor = orticultor; fechaCreacion = fechaCreacion; temporadaActual = temporadaActual};
        viveroList.put(id, newPost);
        Debug.print("Vivero actualizado con ID: " # id);
        return true;
      };
    };
  };

  public func eliminarVivero(id: Text) : async Bool {
    let vivero : ?Vivero = viveroList.get(id);
    switch (vivero) {
      case (null) {
        return false;
      };
      case (_) {
        ignore viveroList.remove(id);
        Debug.print("Eliminar vivero con ID: " # id);
        return true;
      };
    };
  };
};