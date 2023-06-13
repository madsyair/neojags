/*
  This code copied and modified from runjags package

	Copyright (C) 2013 Matthew Denwood <matthewdenwood@mac.com> and Achmad Syahrul Choir <madsyair@gmail.com>

	This code is based on the source code for JAGS and the following tutorial:
	Wabersich, D., Vandekerckhove, J., 2013. Extending JAGS: A tutorial on
	adding custom distributions to JAGS (with a diffusion model example).
	Behavior Research Methods.
	JAGS is Copyright (C) 2002-10 Martyn Plummer, licensed under GPL-2

	This version of the module is compatible with JAGS version 3 and 4.
	Some necessary modifications are controlled using the INCLUDERSCALARDIST
	macro which is defined by makevars if JAGS version 3 is detected.
	Once JAGS version 3 becomes obsolete the redundant code will be
	removed from neojags.

  neojags is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  neojags is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with runjags  If not, see <http://www.gnu.org/licenses/>.

 */

// Checks the JAGS version and sets necessary macros:
#include "jagsversions.h"


#ifndef INCLUDERSCALARDIST
	// For JAGS version >=4

#include <module/Module.h>

#include <function/DFunction.h>
#include <function/PFunction.h>
#include <function/QFunction.h>

//#include "functions/myfun.h"
#include "distributions/DGmsnburr.h"
#include "distributions/DMsnburr.h"
#include "distributions/DMsnburr2a.h"
#include "distributions/DSkewnf.h"
#include "distributions/DSkewtf.h"
#include "distributions/DLep.h"
#include "distributions/DFossep.h"
#include "distributions/DJsep.h"
using std::vector;

namespace jags {
namespace neojags {

	class neojagsModule : public Module {
	  public:
	    neojagsModule();
	    ~neojagsModule();

		void Rinsert(RScalarDist *dist);
	};

neojagsModule::neojagsModule() : Module("neojags")
{
  // insert is the standard way to add a distribution or function
  // insert(new myfun);
  // insert(new mydist);

  // Rinsert (copied from jags) adds the distribution, as well as d,f,q functions simultaneously:
  Rinsert(new DGmsnburr);
  Rinsert(new DMsnburr);
  Rinsert(new DMsnburr2a);
  Rinsert(new DSkewnf);
  Rinsert(new DSkewtf);
  Rinsert(new DLep);
  Rinsert(new DFossep);
  Rinsert(new DJsep);

}



// From jags:
void neojagsModule::Rinsert(RScalarDist *dist)
{
	insert(dist);
	insert(new DFunction(dist));
	insert(new PFunction(dist));
	insert(new QFunction(dist));
}


neojagsModule::~neojagsModule()
{
  vector<Function*> const &fvec = functions();
  for (unsigned int i = 0; i < fvec.size(); ++i) {
    delete fvec[i];
  }
  vector<Distribution*> const &dvec = distributions();
  for (unsigned int i = 0; i < dvec.size(); ++i) {
    delete dvec[i];
  }
}

}  // namespace neojags
}  // namespace jags

jags::neojags::neojagsModule _neojags_module;



#else
	// For JAGS version <=3

#include <Module.h>

#include "distributions/jags/DFunction.h"
#include "distributions/jags/QFunction.h"
#include "distributions/jags/PFunction.h"

//#include "functions/myfun.h"
#include "distributions/DGmsnburr.h"
#include "distributions/DMsnburr.h"
#include "distributions/DMsnburr2a.h"
#include "distributions/DSkewnf.h"
#include "distributions/DSkewtf.h"
#include "distributions/DLep.h"
#include "distributions/DFossep.h"
#include "distributions/DJsep.h"

using std::vector;

namespace neojags {

	class neojagsModule : public Module {
	  public:
	    neojagsModule();
	    ~neojagsModule();

		void Rinsert(RScalarDist *dist);
	};

neojagsModule::neojagsModule() : Module("neojags")
{
  // insert is the standard way to add a distribution or function
  // insert(new myfun);
  // insert(new mydist);

  // Rinsert (copied from jags) adds the distribution, as well as d,f,q functions simultaneously:
  Rinsert(new DGmsnburr);
  Rinsert(new DMsnburr);
  Rinsert(new DMsnburr2a);
  Rinsert(new DSkewnf);
  Rinsert(new DSkewtf);
  Rinsert(new DLep);
  Rinsert(new DFossep);
  Rinsert(new DJsep);

}


// From jags:
void neojagsModule::Rinsert(RScalarDist *dist)
{
	insert(dist);
	insert(new DFunction(dist));
	insert(new PFunction(dist));
	insert(new QFunction(dist));
}


neojagsModule::~neojagsModule()
{
  vector<Function*> const &fvec = functions();
  for (unsigned int i = 0; i < fvec.size(); ++i) {
    delete fvec[i];
  }
  vector<Distribution*> const &dvec = distributions();
  for (unsigned int i = 0; i < dvec.size(); ++i) {
    delete dvec[i];
  }
}

}  // namespace neojags
neojags::neojagsModule _neojags_module;


#endif  /* INCLUDERSCALARDIST */



