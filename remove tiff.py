import os
import glob

def remove_tiff_files(directory):
    """Removes all .tiff and .tif files from the specified directory.

    Args:
        directory: The path to the directory.
    """
    # Search for .tiff files
    tiff_files = glob.glob(os.path.join(directory, '*.tiff'))
    
    # Search for .tif files
    tif_files = glob.glob(os.path.join(directory, '*.tif'))
    
    # Combine the lists
    all_files = tiff_files + tif_files
    
    # Remove each file
    for filename in all_files:
        try:
            os.remove(filename)
            print(f"Removed: {filename}")
        except Exception as e:
            print(f"Error removing {filename}: {e}")
    
    print(f"Total files removed: {len(all_files)}")

# Example usage:
directory_path = '/home/drs93/Python Projects/plankton/images/Plankton_PrivateTest_Converted/zig_zag_rois'
remove_tiff_files(directory_path)