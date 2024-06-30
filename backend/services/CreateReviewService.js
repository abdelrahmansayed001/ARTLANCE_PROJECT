import { reviewData } from "../constants/userData.js";
import reviewDataValidator from "../utils/reviewDataValidator.js";

const { CONTENT, RATE } = reviewData;

const CreateReviewService = ({ content, rate }) => {

  reviewDataValidator(CONTENT, content);
  reviewDataValidator(RATE, rate);

  return {
    content,
    rate
  }

};

export default CreateReviewService;
