IF (NOT CUDAToolkit_ROOT)
  IF (NOT CUDA_ROOT)
    SET(CUDA_ROOT $ENV{CUDA_ROOT})
  ENDIF()
  IF(CUDA_ROOT)
    SET(CUDAToolkit_ROOT ${CUDA_ROOT})
  ENDIF()
ENDIF()

IF(CMAKE_VERSION VERSION_GREATER_EQUAL "3.17.0")
  find_package(CUDAToolkit REQUIRED)
  KOKKOS_CREATE_IMPORTED_TPL(CUDA INTERFACE
    LINK_LIBRARIES CUDA::cuda_driver CUDA::cudart
  )
  KOKKOS_EXPORT_CMAKE_TPL(CUDAToolkit REQUIRED)
ELSE()
  include(${CMAKE_CURRENT_LIST_DIR}/CudaToolkit.cmake)

  IF (TARGET CUDA::cudart)
    SET(FOUND_CUDART TRUE)
    KOKKOS_EXPORT_IMPORTED_TPL(CUDA::cudart)
  ELSE()
    SET(FOUND_CUDART FALSE)
  ENDIF()

  IF (TARGET CUDA::cuda_driver)
    SET(FOUND_CUDA_DRIVER TRUE)
    KOKKOS_EXPORT_IMPORTED_TPL(CUDA::cuda_driver)
  ELSE()
    SET(FOUND_CUDA_DRIVER FALSE)
  ENDIF()

  include(FindPackageHandleStandardArgs)
  IF(KOKKOS_CXX_HOST_COMPILER_ID STREQUAL NVHPC)
    SET(KOKKOS_CUDA_ERROR "Using NVHPC as host compiler requires at least CMake 3.20.1")
  ELSE()
    SET(KOKKOS_CUDA_ERROR DEFAULT_MSG)
  ENDIF()
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(TPLCUDA ${KOKKOS_CUDA_ERROR} FOUND_CUDART FOUND_CUDA_DRIVER)
  IF (FOUND_CUDA_DRIVER AND FOUND_CUDART)
    KOKKOS_CREATE_IMPORTED_TPL(CUDA INTERFACE
      LINK_LIBRARIES CUDA::cuda_driver CUDA::cudart
    )
  ENDIF()
ENDIF()
