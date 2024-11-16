export const fetchBlocks = async () => {
  try {
    const response = await fetch(
      "https://eth.blockscout.com/api/v2/blocks?type=block",
      {
        headers: {
          accept: "application/json",
        },
      }
    );
    const data = await response.json();
    // Gets hash of the latest block
    return data.items[0].hash;
  } catch (error) {
    console.error("Error fetching blocks:", error);
    throw error;
  }
};
