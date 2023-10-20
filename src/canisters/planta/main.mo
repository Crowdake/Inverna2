import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Vivero "canister:vivero";

actor Planta {

	type plantaId = Nat32;
	type Planta = {
		viveroId: Text;
		nombre: Text;
		nombreCientifico: Text;
		nitrogeno: Float;
		fosforo: Float;
		potasio: Float;
		calcio: Float;
		magnesio: Float;
		zinc: Float;
		boro: Float;
		molibdeno: Float;
		manganeso: Float;
		cloro: Float;
		cobre: Float;
		co2: Float;
		h2o: Float;
		humedad: Float;
		
	};

	stable var plantaId: plantaId = 0;
	let plantaList = HashMap.HashMap<Text, Planta>(0, Text.equal, Text.hash);

	private func generateTaskId() : Nat32 {
		plantaId += 1;
		return plantaId;
	};

	public shared (msg) func createPlant(viveroId: Text, nombre: Text, nombreCientifico: Text, nitrogeno: Float, fosforo: Float, potasio: Float, calcio: Float, magnesio: Float, zinc: Float, boro: Float, molibdeno: Float, manganeso: Float, cloro: Float, cobre: Float, co2: Float, h2o: Float, luz: Float, humedad: Float) : async () {
  let planta = {viveroId=viveroId; nombre=nombre; nombreCientifico=nombreCientifico; nitrogeno=nitrogeno; fosforo=fosforo; potasio=potasio; calcio=calcio; magnesio=magnesio; zinc=zinc; boro=boro; molibdeno=molibdeno; manganeso=manganeso; cloro=cloro; cobre=cobre; co2=co2; h2o=h2o; luz=luz; humedad=humedad};
  
  // Verificar si el vivero existe
  let vivero: ?Vivero.Vivero = await Vivero.obtenerVivero(viveroId);
  switch (vivero) {
    case (null) {
      Debug.print("El vivero con el ID especificado no existe");
      return ();
    };
    case (_) {
      // El vivero existe, continuar con la creación de la planta
      plantaList.put(Nat32.toText(generateTaskId()), planta);
      Debug.print("New planta created! ID: " # Nat32.toText(plantaId));
      return ();
    };
  };
};

	public query func obtenerPlantas () : async [(Text, Planta)] {
		let plantaIter : Iter.Iter<(Text, Planta)> = plantaList.entries();
		let plantaArray : [(Text, Planta)] = Iter.toArray(plantaIter);

		return plantaArray;
	};

	public query func obtenerPlanta (id: Text) : async ?Planta {
		let planta: ?Planta = plantaList.get(id);
		return planta;
	};

	public shared (msg) func actualizarPlanta (id: Text, viveroId: Text, nombre: Text, nombreCientifico: Text, nitrogeno: Float, fosforo: Float, potasio: Float, calcio: Float, magnesio: Float, zinc: Float, boro: Float, molibdeno: Float, manganeso: Float, cloro: Float, cobre: Float, co2: Float, h2o: Float, luz: Float, humedad: Float) : async Bool {
		let planta: ?Planta = plantaList.get(id);
		

		switch (planta) {
			case (null) {
				return false;
			};
			case (?currentPost) {
				let nuevaPlanta: Planta = {viveroId=viveroId; nombre=nombre; nombreCientifico=nombreCientifico; nitrogeno=nitrogeno; fosforo=fosforo; potasio=potasio; calcio=calcio; magnesio=magnesio; zinc=zinc; boro=boro; molibdeno=molibdeno; manganeso=manganeso; cloro=cloro; cobre=cobre; co2=co2; h2o=h2o; luz=luz; humedad=humedad};
				plantaList.put(id, nuevaPlanta);
				Debug.print("Updated planta with ID: " # id);
				return true;
			};
		};

	};

	public func eliminarPlanta (id: Text) : async Bool {
		let planta : ?Planta = plantaList.get(id);
		switch (planta) {
			case (null) {
				return false;
			};
			case (_) {
				ignore plantaList.remove(id);
				Debug.print("Delete planta with ID: " # id);
				return true;
			};
		};
	};
}