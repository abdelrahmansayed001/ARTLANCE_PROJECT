const CalculateFreelancerRateService = (rates) => {
    const ratesSum = rates.reduce((acc, cur) => acc + cur, 0);
    return Math.round(((ratesSum / rates.length) + Number.EPSILON) * 100) / 100;
}

export default CalculateFreelancerRateService;