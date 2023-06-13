# This file is copied and modified from runjags package
# Copyright (C) 2013 Matthew Denwood <matthewdenwood@mac.com> and Achmad Syahrul Choir <madsyair@gmail.com>
# 
# This code allows the distributions provided by the neojags module
# to be tested from within R.  
# 
# This version of the module is compatible with JAGS version 3 and 4.
# Some necessary modifications are controlled using the INCLUDERSCALARDIST
# macro which is defined by makevars if JAGS version 3 is detected.
# Once JAGS version 3 becomes obsolete the redundant code will be
# removed from neojags.
# 
# neojags is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# neojags is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with runjags  If not, see <http://www.gnu.org/licenses/>.

test_that("basic example works", {
  getex <- neojags:::example_neojags()
})
