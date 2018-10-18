/*[M]=BuildBurstMatrix(indexchannel,t,Bind(first:last),width,class);
 * t and Bind must be rounded.
 * a function that returns a matrix of selected bursts.
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "mex.h"
#include "matrix.h"

/********************************************************************************************/
/*This function defines the incoming and outgoing matlab variables
 * and sets pointers to the begining of each one. Then calls to the
 * function that makes the new SBEmatrix and to the correlation calculation
 * (the in comming array must me all in the same unit)*/

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    double matClass,siz1,siz2,siz3;
    int dims[3];
    double sizeOfDataInKilobytes;
    mwIndex i;
    uint8_T tt;
    size_t numberOfElements;
    
    if (nrhs<4)
    {
        mexPrintf("\nThe number of variables entered is: %d\n",nrhs);
    }

    matClass = mxGetScalar(prhs[0]);
    
    siz1 = mxGetScalar(prhs[1]);
    dims[0]=(int)siz1;
    siz2 = mxGetScalar(prhs[2]);
    dims[1]=(int)siz2;
    siz3 = mxGetScalar(prhs[3]);
    dims[2]=(int)siz3;
    
    mexPrintf("\nInput dimensions: : %u x %u x %u\n", dims[0], dims[1], dims[2]);
    
    /* Set the output pointers :*/
    if (matClass==2)
    {
        plhs[0] = mxCreateNumericArray((mwSize)3, (mwSize)dims, mxUINT8_CLASS, mxREAL);
    }
    if (matClass==1)
    {
        plhs[0] = mxCreateNumericArray((mwSize)3, (mwSize)dims,mxDOUBLE_CLASS,mxREAL);  //return burst matrix (M)
    }
    uint8_T M;
    
        
    /* Display the mxArray's size. */
    numberOfElements = mxGetNumberOfElements(plhs[0]);
    sizeOfDataInKilobytes = numberOfElements * mxGetElementSize(plhs[0]) / 1024.0;
    mexPrintf("Size of array in kilobytes: %.0f\n\n", sizeOfDataInKilobytes);
    
    
    
    
    /* Display the mxArray's dimension. */
    


}
