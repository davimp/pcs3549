#include "lago.h"
#include <bits/stdc++.h>
#include <stdlib.h>

using namespace godot;

void Lago::_register_methods() 
{
	register_method("insere", &Lago::insere);
	register_method("printa", &Lago::printa);
	register_method("pol", &Lago::pol);
	register_property<Lago, int>("tam_pol", &Lago::tam_pol, 0);
	
	//register_method("_init", &Lago::_init);
	//register_property<GDExample, float>("amplitude", &GDExample::amplitude, 10.0);

	//register_signal<GDExample>((char *)"position_changed", "node", GODOT_VARIANT_TYPE_OBJECT, "new_pos", GODOT_VARIANT_TYPE_VECTOR2);
}

Lago::Lago() 
{
	ff = std::fopen("tela.txt", "w");	
	p = 1;
}

Lago::~Lago()
{

}

void Lago::printa()
{
	// add your cleanup here
	std::string s;	
	
	
	for(i = 0; i < 1280;i++)
	{
		s = "";
		for(j = 0; j < 720;j++)
		{
			//if (mapa[i*LIM + j] || 1) continue;
			s += std::to_string(mapa[i*LIM + j]);
		}
		//Godot::print(s.data());
		std::fprintf(ff,"%s\n",s.data());
	}
	
	std::fclose(ff);
}

void Lago::_init() {
	// initialize any variables here
	Godot::print("Testando");
}

void Lago::insere(Vector2 v, Vector2 u)
{
	v.x = std::round(v.x);
	v.y = std::round(v.y);
	u.x = std::round(u.x);
	u.y = std::round(u.y);

	if(v == u)
		return;

	//Vector2 z = (v-u).normalized();
	
	i = v.x;
	j = v.y;
	mi = u.x;
	mj = u.y;
	
	bool ni,nj;
	
	ni = v.x < u.x;
	nj = v.y < u.y;
	
	int k = 0;
	
	linhas[p] = {v, u};
	
	printf("===>%d\n",p);
	

	if(p > 1)
	{
		ligacao[p].insert(p-1);
		ligacao[p-1].insert(p);
	}

	//if(p == 1)


	if(0)
	{
		Godot::print(v);
		Godot::print(u);
		Godot::print("--------------------");
		
	}


	while(i != mi || j != mj)
	{
		if(mapa[i*LIM + j])
		{
			k = mapa[i*LIM + j];
			if(ligacao[p].find(k) == ligacao[p].end())
			{
				ligacao[p].insert(k);
				ligacao[k].insert(p);

				Godot::print((std::to_string(k) + " >---< " + std::to_string(p)).data());
				
				procura_ciclo(p);
				
			}
			//ciclo?
		}
		else
			mapa[i*LIM+j] = p;
		
		//Godot::print((std::to_string(i) + " " + std::to_string(j)).data());
		//Godot::print((std::to_string((mi - i)*(mi - i)) + "<-->" + std::to_string((mj - j)*(mj - j))).data());
		
		if((mi - i)*(mi - i) > (mj - j)*(mj - j))
		{
			if(ni)
				i++;
			else
				i--;
		}
		else
		{
			if(nj)
				j++;
			else
				j--;
			
		}
	}
	
	{
		if(mapa[i*LIM + j])
		{
			k = mapa[i*LIM + j];
			if(ligacao[p].find(k) == ligacao[p].end())
			{
				ligacao[p].insert(k);
				ligacao[k].insert(p);

				//Godot::print((std::to_string(k) + " " + std::to_string(p)).data());
				
				procura_ciclo(p);
				
			}
			//ciclo?
		}
		else
			mapa[i*LIM+j] = p;
		
		//Godot::print((std::to_string(i) + " " + std::to_string(j)).data());
		//Godot::print((std::to_string((mi - i)*(mi - i)) + "<-->" + std::to_string((mj - j)*(mj - j))).data());
		
		if((mi - i)*(mi - i) > (mj - j)*(mj - j))
		{
			if(ni)
				i++;
			else
				i--;
		}
		else
		{
			if(nj)
				j++;
			else
				j--;
			
		}
	}


	p++;

	
	
	
}

void Lago::procura_ciclo(int x)
{
	int y;

	for(int a = 0; a<=p; a++)
		pai[a] = -1;
	
	std::queue<int> q;

	pai[x] = 0;
	q.push(x);

	/* Fiz errado, era pra ser uma bfs */
	/*
	while(!q.empty())
	{
		y = q.front();
		q.pop();
		//Godot::print(("------> " + std::to_string(y) + " -- " + std::to_string(pai[y])).data());

		for(auto z:ligacao[y])
		{
			/* Achou ciclo *//*
			if(y == 2)
				Godot::print((std::to_string(z) + " <--22--> "
				 + std::to_string(pai[z]) + " PAI --> " + std::to_string(pai[y])).data());
			if(pai[z] != -1 && pai[z] != y && z != pai[y])
			{
				Godot::print((std::to_string(z) + "<-entrou-> " + std::to_string(pai[z])).data());
				//ciclos.insert({std::max(z, pai[z]), std::min(z, pai[z])});
				ciclos.insert({z, pai[z]});
				continue;
			}
			if(pai[z] != -1)
				continue;
			pai[z] = y;
			q.push(z);
		}
	}

	*/

	dfs(x);

	int k = 0;

	for(auto z:ciclos)
	{
		x = z.first;
		y = z.second;
		PoolVector2Array aux;


		for(int a = 0; a<=p; a++)
			pai[a] = -1;
		
		dfs2(y);


		aux.push_back(linhas[x].first);
		aux.push_back(linhas[y].second);
		
		//Godot::print(linhas[x].first);
		//Godot::print(linhas[y].second);
		Godot::print((std::to_string(x) + " " + std::to_string(y)).data());

		x = pai[x];

			Godot::print((std::to_string(x) + " <-> " + std::to_string(pai[x])).data());

		while(x != y)
		{
			Godot::print((std::to_string(x) + " <-> " + std::to_string(pai[x])).data());
			aux.push_back(linhas[x].first);
			//aux.push_back(linhas[x].second);
			x = pai[x];
		}
	
		pols.push_back(aux);
		k++;


	}

	Godot::print((" ======> " + std::to_string(k)).data());

	tam_pol = pols.size();

	ciclos.clear();


}

PoolVector2Array Lago::pol(int x)
{
	return pols[x];
}

void Lago::dfs(int x)
{
	for(auto y:ligacao[x])
	{
		if(x == 2)
			Godot::print((std::to_string(y) + " <--22--> "
				+ std::to_string(pai[y]) + " PAI --> " + std::to_string(pai[x])).data());

		/* Achou ciclo */
		if(pai[y] != -1 && pai[y] != x && y != pai[x])
		{
			Godot::print((std::to_string(y) + "<-entrou-> " + std::to_string(x)).data());
			//ciclos.insert({std::max(z, pai[z]), std::min(z, pai[z])});
			ciclos.insert({y, x});
			continue;
		}
		if(pai[y] != -1)
			continue;
		pai[y] = x;
		dfs(y);
	}
}


void Lago::dfs2(int x)
{
	for(auto y:ligacao[x])
	{
		if(pai[y] != -1)
			continue;
		pai[y] = x;
		dfs(y);
	}
}

/*
void Lago::dfs(int x, int y)
{
	//Godot::print((std::to_string(x) + " " + std::to_string(y)).data());
	//puts("TTTTT");
	for(int aa = -1; aa < 2;aa+=2)
	{
		if(x + aa < 0 || x + aa >= 100)
			continue;
		for(int bb = -1; bb < 2; bb += 2)
		{
			if(y + bb < 0 || y + bb >= 100)
				continue;
			if(visitado[x + aa][y+bb] || mapa[(x + aa)*LIM + y+bb] == 9) continue;
				
			visitado[x + aa][y+bb] = 1;
			mapa[(x + aa)*LIM + y+bb] = mapa[x*LIM + y];
			dfs(x + aa, y+bb);
			
		}
	}
}
*/


void Lago:: mapeia(Vector2 v, int x)
{
	mapa[v.x * LIM + v.y] = x;
}

int Lago:: mapeio(Vector2 v)
{
	return mapa[v.x * LIM + v.y];
}



