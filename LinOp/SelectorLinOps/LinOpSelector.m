classdef LinOpSelector <  LinOp
    % Selector linear operator which extracts specific entries of a vector
    % $$\\mathrm{H} : \\mathrm{x} \\mapsto \\mathrm{x}_{\\mathrm{sel}} $$
    % where \\(\\mathrm{sel}\\) is a subset of selected indexes.
    %
    % :param sel: boolean with true at selected positions
    %
    % All attributes of parent class :class:`LinOp` are inherited. 
    %
    % **Note** The output of the :meth:`apply` method will be a colunm
    % vector whatever the given parameter sel. For specific selectors
    % (i.e., downsampling or patch see :class:`LinOpDownsample` and
    % :class:`LinOpSelectorPatch`)
    %
    % See also :class:`LinOp`, :class:`LinOpSelectorPatch`,
    % :class:`LinOpDownsample`.
    
    %     Copyright (C) 2015 F. Soulez ferreol.soulez@epfl.ch E. Soubies
    %     emmanuel.soubies@epfl.ch
    %
    %     This program is free software: you can redistribute it and/or modify
    %     it under the terms of the GNU General Public License as published by
    %     the Free Software Foundation, either version 3 of the License, or
    %     (at your option) any later version.
    %
    %     This program is distributed in the hope that it will be useful,
    %     but WITHOUT ANY WARRANTY; without even the implied warranty of
    %     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %     GNU General Public License for more details.
    %
    %     You should have received a copy of the GNU General Public License
    %     along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties (SetAccess = protected,GetAccess = public)
        sel;         % boolean
    end
    methods
        function this = LinOpSelector(sel)
            this.name ='LinOp Selector';
            if nargin==0
                sel=false;
            end
            this.iscomplex= false;
            assert(islogical(sel),'The input selector should be boolean');            
			this.norm = 1;			
            this.sizeout=[sum(sel(:)), 1];
            this.sel = sel;
            this.sizein=size(sel);
            this.isinvertible=false;
        end        
        function y = apply(this,x)
            % Reimplemented from parent class :class:`LinOp`.           
            assert(isequal(size(x),this.sizein),  'x does not have the right size: [%d, %d, %d,%d]',this.sizein);
            y =x(this.sel);
        end        
        function y = adjoint(this,x)
            % Reimplemented from parent class :class:`LinOp`.  
            assert( isequal(size(x),this.sizeout),  'x does not have the right size: [%d, %d, %d,%d,%d]',this.sizeout);
            y = zeros(this.sizein);
            y(this.sel) = x;
        end
        function y = HtH(this,x)
            % Reimplemented from parent class :class:`LinOp`.  
            assert( isequal(size(x),this.sizein),  'x does not have the right size: [%d, %d, %d,%d]',this.sizein);
            y = zeros(this.sizein);
            y(this.sel) = x(this.sel);            
        end
        function y = HHt(this,x)
            % Reimplemented from parent class :class:`LinOp`.  
            assert( isequal(size(x),this.sizeout),  'x does not have the right size: [%d, %d, %d,%d,%d]',this.sizeout);
            y = x;
        end
    end
end
