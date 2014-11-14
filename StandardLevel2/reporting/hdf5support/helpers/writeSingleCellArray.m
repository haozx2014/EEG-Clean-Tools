function writeSingleCellArray(fileId, dataset, value)
% Writes a double cell dataset to the specified HDF5 file
%
% writeSingleCellArray(fileId, dataset, value)
%
% Input:
%   fileId            The file id 
%   dataset           The path of the dataset 
%   value             The value of the dataset
%

valueType = H5T.vlen_create('H5T_NATIVE_FLOAT');
dims = size(value);
flippedDims = fliplr(dims);
spaceId = H5S.create_simple(ndims(value),flippedDims, []);
datasetId = H5D.create(fileId, dataset, valueType, spaceId, ...
    'H5P_DEFAULT');
H5D.write(datasetId, valueType, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', ...
    value);
H5D.close(datasetId);
H5S.close(spaceId);

end % writeCellArray

