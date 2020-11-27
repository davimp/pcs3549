#ifndef LAGO_H
#define LAGO_H

#include <Godot.hpp>
#include <Node.hpp>
#include <gdnative/vector2.h>
#include <bits/stdc++.h>
#include <stdlib.h>
#include <PoolArrays.hpp>

#define LIM 2000

namespace godot {

class Lago : public Node {
	GODOT_CLASS(Lago, Node)

private:

	int i,j,mi,mj;
	double ii,jj;
	int p;
	bool visitado[1280][720];
	std::pair<Vector2, Vector2> linhas[100000];
	std::set<int> ligacao[100000];
	int pai[100000];
	std::set< std::pair<int, int> > ciclos;
	std::FILE *ff;

public:
	static void _register_methods();

	Lago();
	~Lago();
	
	std::unordered_map<int,int> mapa;
	
	void mapeia(Vector2 v, int x);
	int mapeio(Vector2 v);
	
	void insere(Vector2 v, Vector2 u);
	
	void printa();
	
	void dfs(int x);
	
	void dfs2(int x);
	
	void procura_ciclo(int x);

	void _init(); // our initializer called by Godot
	
	int tam_pol;
	
	PoolVector2Array pol(int x);
	
	std::vector<PoolVector2Array> pols;

};

}

#endif
