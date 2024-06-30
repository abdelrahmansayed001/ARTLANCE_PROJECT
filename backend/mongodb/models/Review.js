import { Schema, model } from "mongoose";

export const ReviewSchema = new Schema({
  content: { type: String, required: true },
  from: { type: Schema.Types.ObjectId, ref: "Client", required: true },
  to: { type: Schema.Types.ObjectId, ref: "Freelancer", required: true },
  rate: { type: Number, enum: [1, 2, 3, 4, 5], required: true },
  date: { type: Date, default: Date.now }
});

const ReviewModel = model("Review", ReviewSchema);

export default ReviewModel;
