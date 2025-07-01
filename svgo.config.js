module.exports = {
  multipass: true,
  plugins: [
    { name: 'removeDimensions' },
    {
      name: 'addAttributesToSVGElement',
      params: {
        attributes: [{ viewBox: '0 0 100 100' }]
      }
    }
  ]
};