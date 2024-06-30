import {
    isNull,
    isEmpty,
    isString,
    isBetween,
    isNum,
  } from "./checkValidity.js";
import AppError from "../constants/AppError.js";
import { errorEnum } from "../constants/errorCodes.js";
import { reviewData } from "../constants/userData.js";
  
const { INVALID_REVIEW_CONTENT, INVALID_REVIEW_RATE, ALL_FIELDS_REQUIRED } = errorEnum;
const { CONTENT, RATE } = reviewData;

const reviewDataValidator = (dataType, data) => {
    switch(dataType){
        case CONTENT:
            if(isNull(data) || isEmpty(data))
                throw new AppError(ALL_FIELDS_REQUIRED);
            if(!isString(data) || !isBetween(4, data.length, 201))
                throw new AppError(INVALID_REVIEW_CONTENT);

        break;

        case RATE:
          if (isNull(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!(isNum(data) && isBetween(0, data, 6)))
            throw new AppError(INVALID_REVIEW_RATE);

        break;
        
        default:
            if (isNull(data)) throw new AppError(ALL_FIELDS_REQUIRED);
    }
}

export default reviewDataValidator;